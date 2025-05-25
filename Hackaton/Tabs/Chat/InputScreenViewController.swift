import UIKit
import AVFoundation

final class InputScreenViewController: UIViewController {

    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var audioPlayer: AVAudioPlayer?

    // Картинка PNG сверху
    private let headerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "skazki"))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let textView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 16)
        tv.textColor = .white
        tv.backgroundColor = UIColor(hex: "#5A5F89FF")
        tv.layer.cornerRadius = 20
        tv.layer.borderColor = UIColor(hex: "#C9BBF2FF").cgColor
        tv.layer.borderWidth = 2
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        tv.autocapitalizationType = .sentences
        tv.returnKeyType = .done
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Жомок жөнүндө кыскача"
        label.textColor = .placeholderText
        label.font = .systemFont(ofSize: 16)
        label.isUserInteractionEnabled = false
        return label
    }()

    private let actionButton = CustomButton(title: "Жүктөө")

    private var activeField: UITextView?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let audioControlsContainer: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 8
            stack.alignment = .center
            return stack
        }()
        
        private let playbackSlider: UISlider = {
            let slider = UISlider()
            slider.minimumValue = 0
            slider.maximumValue = 1
            slider.isContinuous = true
            return slider
        }()
        
        private let timeLabelsStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .equalSpacing
            stack.alignment = .center
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        private let currentTimeLabel: UILabel = {
            let label = UILabel()
            label.text = "00:00"
            label.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
            label.textColor = .secondaryLabel
            return label
        }()
        
        private let durationLabel: UILabel = {
            let label = UILabel()
            label.text = "00:00"
            label.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
            label.textColor = .secondaryLabel
            return label
        }()
        
        private let buttonsStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 30
            stack.alignment = .center
            return stack
        }()
        
        private let playPauseButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "play.fill"), for: .normal)
            button.tintColor = .systemPurple
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 40).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            return button
        }()
        
        private let stopButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            button.tintColor = .systemRed
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 40).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            return button
        }()
        
        private var playbackTimer: Timer?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Жомок ойлоп табуу"
        setupUI()
        setupActions()
        setupKeyboardHandling()
        setupAudioControls()
        actionButton.updateState(isEnabled: false)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#464C75FF")
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        [headerImageView, textView, placeholderLabel, actionButton, spinner].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            headerImageView.heightAnchor.constraint(equalToConstant: 120),

            textView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 40),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150),

            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 12),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -16),

            actionButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 30),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),

            spinner.centerXAnchor.constraint(equalTo: actionButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: actionButton.centerYAnchor)
        ])
    }

    // MARK: - Actions
    private func setupActions() {
        textView.delegate = self
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false // это позволяет другим элементам (кнопкам и т.п.) обрабатывать нажатия
        view.addGestureRecognizer(tap)
    }


    @objc private func endEditing() {
        view.endEditing(true)
    }

    @objc private func actionButtonTapped() {
        guard isFormValid else { return }

        actionButton.isEnabled = false
        actionButton.setTitle("", for: .normal)
        spinner.startAnimating()

        sendTextToServer(text: textView.text ?? "")
    }

    // MARK: - Keyboard Handling
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height + 20, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets

        if let activeField = activeField {
            let rect = activeField.convert(activeField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect, animated: true)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    //MARK: - Audio setup
    private func setupAudioControls() {
            audioControlsContainer.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(audioControlsContainer)

            audioControlsContainer.addArrangedSubview(playbackSlider)
            audioControlsContainer.addArrangedSubview(timeLabelsStack)
            audioControlsContainer.addArrangedSubview(buttonsStack)

            timeLabelsStack.addArrangedSubview(currentTimeLabel)
            timeLabelsStack.addArrangedSubview(durationLabel)

            buttonsStack.addArrangedSubview(playPauseButton)
            buttonsStack.addArrangedSubview(stopButton)

            NSLayoutConstraint.activate([
                audioControlsContainer.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 20),
                audioControlsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                audioControlsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                audioControlsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
                playbackSlider.widthAnchor.constraint(equalTo: audioControlsContainer.widthAnchor),
            ])

            audioControlsContainer.isHidden = true

            playbackSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
            playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
            stopButton.addTarget(self, action: #selector(stopTapped), for: .touchUpInside)
        }

    // MARK: - Validation
    private var isFormValid: Bool {
        !textView.text.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // MARK: - Network Request
    private func sendTextToServer(text: String) {
        guard let url = URL(string: "http://192.168.0.168:5000/tts") else {
            showAlert(title: "Ошибка", message: "Неверный URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["text": text]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            showAlert(title: "Ошибка", message: "Не удалось сериализовать данные")
            resetButton()
            return
        }

        URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
            DispatchQueue.main.async {
                self.resetButton()
            }

            if let error = error {
                print("❌ Ошибка сети: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Ошибка", message: "Проверьте интернет")
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                print("❌ Неверный ответ сервера")
                DispatchQueue.main.async {
                    self.showAlert(title: "Ошибка", message: "Сервер вернул ошибку")
                }
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: String],
                   let audioURLString = json["audio_url"],
                   let audioURL = URL(string: audioURLString) {

                    print("✅ Получена ссылка на аудио: \(audioURLString)")
                    self.downloadAudio(from: audioURL)
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Ошибка", message: "Некорректный ответ от сервера")
                    }

                    // 👉 Вставь отладку:
                    let raw = String(data: data, encoding: .utf8) ?? "Не удалось декодировать данные"
                    print("📦 Сырые данные от сервера: \(raw)")
                }
            } catch {
                print("❌ Ошибка парсинга JSON: \(error.localizedDescription)")

                // 👉 Тоже вставь отладку:
                let raw = String(data: data, encoding: .utf8) ?? "Не удалось декодировать данные"
                print("📦 Сырые данные при ошибке парсинга: \(raw)")
                
                DispatchQueue.main.async {
                    self.showAlert(title: "Ошибка", message: "Не удалось прочитать ответ сервера")
                }
            }
        }.resume()
    }
    
    private func downloadAudio(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Ошибка при загрузке аудио: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Ошибка", message: "Не удалось загрузить аудио")
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Ошибка", message: "Пустой ответ при загрузке аудио")
                }
                return
            }

            DispatchQueue.main.async {
                self.playAudio(from: data)
            }
        }.resume()
    }
    
    private func playAudio(from data: Data) {
        do {
            self.audioPlayer = try AVAudioPlayer(data: data)
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.play()
            print("🔊 Воспроизведение аудио началось")
        } catch {
            print("❌ Ошибка воспроизведения: \(error.localizedDescription)")
            showAlert(title: "Ошибка", message: "Не удалось воспроизвести аудио")
        }
    }

    private func resetButton() {
        actionButton.isEnabled = true
        actionButton.setTitle("Продолжить", for: .normal)
        spinner.stopAnimating()
    }

    // MARK: - Helpers
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Audio Player Controls
        
        @objc private func playPauseTapped() {
            guard let player = audioPlayer else { return }

            if player.isPlaying {
                player.pause()
                playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                stopPlaybackTimer()
            } else {
                player.play()
                playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                startPlaybackTimer()
            }
        }
        
        @objc private func stopTapped() {
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0
            playbackSlider.value = 0
            currentTimeLabel.text = "00:00"
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            stopPlaybackTimer()
        }
        
        @objc private func sliderValueChanged(_ sender: UISlider) {
            audioPlayer?.currentTime = TimeInterval(sender.value)
            updateCurrentTimeLabel()
        }
        
        private func startPlaybackTimer() {
            stopPlaybackTimer() // на всякий случай
            playbackTimer = Timer.scheduledTimer(timeInterval: 0.5,
                                                 target: self,
                                                 selector: #selector(updatePlaybackProgress),
                                                 userInfo: nil,
                                                 repeats: true)
        }
        
        private func stopPlaybackTimer() {
            playbackTimer?.invalidate()
            playbackTimer = nil
        }
        
        @objc private func updatePlaybackProgress() {
            guard let player = audioPlayer else { return }
            playbackSlider.value = Float(player.currentTime)
            updateCurrentTimeLabel()
            
            if !player.isPlaying {
                stopPlaybackTimer()
                playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        }
        
        private func updateCurrentTimeLabel() {
            let currentSeconds = Int(audioPlayer?.currentTime ?? 0)
            currentTimeLabel.text = formatTime(seconds: currentSeconds)
        }
        
        private func updateDurationLabel() {
            let durationSeconds = Int(audioPlayer?.duration ?? 0)
            durationLabel.text = formatTime(seconds: durationSeconds)
        }
        
        private func formatTime(seconds: Int) -> String {
            String(format: "%02d:%02d", seconds / 60, seconds % 60)
        }

        // MARK: - Override playAudio

//        private func playAudio(from data: Data) {
//            do {
//                audioPlayer = try AVAudioPlayer(data: data)
//                audioPlayer?.prepareToPlay()
//                
//                // Настраиваем слайдер и время
//                playbackSlider.minimumValue = 0
//                playbackSlider.maximumValue = Float(audioPlayer?.duration ?? 1)
//                playbackSlider.value = 0
//                
//                updateDurationLabel()
//                updateCurrentTimeLabel()
//                
//                audioControlsContainer.isHidden = false
//                
//                audioPlayer?.play()
//                playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
//                startPlaybackTimer()
//                
//                print("🔊 Воспроизведение аудио началось")
//            } catch {
//                print("❌ Ошибка воспроизведения: \(error.localizedDescription)")
//                showAlert(title: "Ошибка", message: "Не удалось воспроизвести аудио")
//            }
//        }

}

// MARK: - UITextViewDelegate
extension InputScreenViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        actionButton.updateState(isEnabled: isFormValid)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        activeField = textView
        textView.layer.borderColor = UIColor.systemPurple.cgColor
        textView.layer.borderWidth = 1.5
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        activeField = nil
        textView.layer.borderColor = UIColor.clear.cgColor
        textView.layer.borderWidth = 0
    }
}
