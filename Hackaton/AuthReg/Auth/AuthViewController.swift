//import UIKit
//
//final class AuthViewController: UIViewController {
//    
//    // MARK: - UI Elements
//    private let titleLabel = UILabel()
//    private let emailField = CustomTextField(placeholder: AuthConstants.emailPlaceholder)
//    private let passwordField = CustomTextField(placeholder: AuthConstants.passwordPlaceholder, isSecure: true)
//    private let loginButton = CustomButton(title: AuthConstants.loginButtonTitle)
//    private let signUpButton = UIButton()
//    
//    private var isPasswordVisible = false
//
//    var isFormValid: Bool {
//        return isValidEmail(emailField.text) && !(passwordField.text?.isEmpty ?? true)
//    }
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemGroupedBackground
//        setupUI()
//        setupActions()
//        loginButton.updateState(isEnabled: false)
//    }
//    
//    // MARK: - Setup UI
//    private func setupUI() {
//        title = AuthConstants.screenTitle
//        
//        titleLabel.text = AuthConstants.titleText
//        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
//        titleLabel.textAlignment = .center
//        
//
//        signUpButton.setTitle(AuthConstants.signUpPrompt, for: .normal)
//        signUpButton.setTitleColor(.systemBlue, for: .normal)
//        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        
//        let container = CustomTextFieldContainer(textFields: [
//            (emailField, AuthConstants.emailLabel),
//            (passwordField, AuthConstants.passwordLabel)
//        ])
//        
//        view.addSubviews(titleLabel, container, loginButton, signUpButton)
//        
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        container.translatesAutoresizingMaskIntoConstraints = false
//        loginButton.translatesAutoresizingMaskIntoConstraints = false
//        signUpButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            container.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
//            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            loginButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 30),
//            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            loginButton.heightAnchor.constraint(equalToConstant: 50),
//            
//            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
//            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
//    }
//    
//    // MARK: - Setup Actions
//    private func setupActions() {
//        emailField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
//        passwordField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
//        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
//        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
//    }
//    
//    @objc private func textFieldsChanged() {
//        loginButton.updateState(isEnabled: isFormValid)
//    }
//    
//  
//    @objc private func loginButtonTapped() {
//        Task {
//            do {
//                let request = LoginRequest(
//                    email: emailField.text ?? "",
//                    password: passwordField.text ?? ""
//                )
//                
//                let response = try await AuthService.shared.loginUser(request)
//                print("Успешный вход. AccessToken: \(response.accessToken)")
//                
//                navigationController?.pushViewController(MainTabBarController(), animated: true)
//            } catch {
//                print("Ошибка при входе: \(error.localizedDescription)")
//                showAlert(title: "Ошибка входа", message: error.localizedDescription)
//            }
//        }
//    }
//    
//    @objc private func signUpButtonTapped() {
//        let registrationVC = RegViewController()
//        navigationController?.pushViewController(registrationVC, animated: true)
//    }
//    
//    // MARK: - Helpers
//    private func isValidEmail(_ email: String?) -> Bool {
//        guard let email = email else { return false }
//        let emailRegex = #"^\S+@\S+\.\S+$"#
//        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
//    }
//    
//    private func showAlert(title: String, message: String) {
//        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alertVC, animated: true)
//    }
//}
