

import UIKit

class ViewManager{
    
    var controller: UIViewController
    var view: UIView
    private let viewService = ViewService.shared
    private var headerStack = UIStackView()
    private var cardsStack = UIStackView()
    
    lazy private var width: CGFloat = {
        return (view.frame.width/2) - 40
    }()
    
    init(controller: UIViewController) {
        self.controller = controller
        self.view = controller.view
        
    }
    
    func createAppHeader(title: String){
        headerStack = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .equalSpacing
            stack.alignment = .center
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        var headerLabel: UILabel {
            let label = UILabel()
            label.text = title
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.textColor = .white
            label.numberOfLines = 0
            return label
        }
        
        let headerBtn = {
            let btn = UIButton(primaryAction: nil)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.widthAnchor.constraint(equalToConstant: 31).isActive = true
            btn.heightAnchor.constraint(equalToConstant: 31).isActive = true
            btn.layer.cornerRadius = 16
            btn.tintColor = .white
            //btn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            
            let gradient = viewService.gradientLayer(startColor: UIColor(hex: "#B2A1F7FF"), frame: CGRect(x: 0, y: 0, width: 31, height: 31))
            btn.layer.addSublayer(gradient)
            
            btn.clipsToBounds = true
            
            let btnImage: UIImageView = {
                let img = UIImageView()
                img.image = UIImage(systemName: "magnifyingglass")
                img.translatesAutoresizingMaskIntoConstraints = false
                img.widthAnchor.constraint(equalToConstant: 18).isActive = true
                img.heightAnchor.constraint(equalToConstant: 18).isActive = true
                
                return img
            }()
            
            btn.addSubview(btnImage)
            
            btnImage.centerYAnchor.constraint(equalTo: btn.centerYAnchor).isActive = true
            btnImage.centerXAnchor.constraint(equalTo: btn.centerXAnchor).isActive = true
            
            
            return btn
        }()
        
        headerStack.addArrangedSubview(headerLabel)
        headerStack.addArrangedSubview(headerBtn)
        
        view.addSubview(headerStack)
        
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            headerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
    
    func createCards(){
        
        let tiktokCard = createLongCardContent( for: viewService.createCardView(gradientColor: "#58CFEFFF", width: width), image: .manas, title: "Манас", rate: 4.9, views: 5435)
        
        let clockCard = createShortCardContent(for: viewService.createCardView(gradientColor: "#5BD6B9FF", width: width), image: .makal, title: "Макал")
        
        let instCard = createShortCardContent(for: viewService.createCardView(gradientColor: "#E79DA7FF", width: width), image: .jomok, title: "Жомок")
        
        
        let youtubeCard = createLongCardContent(for: viewService.createCardView(gradientColor: "#B2A1F7FF", width: width), image: .salt, title: "Салттар", rate: 4.9, views: 123)
        
        
        let lStack = viewService.getSideStack(items: [tiktokCard, clockCard])
        let rStack = viewService.getSideStack(items: [instCard, youtubeCard])
        
        
        cardsStack = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .fill
            stack.distribution = .equalSpacing
            stack.translatesAutoresizingMaskIntoConstraints = false
            
            stack.addArrangedSubview(lStack)
            stack.addArrangedSubview(rStack)
            
            return stack
        }()
        
        view.addSubview(cardsStack)
        
        NSLayoutConstraint.activate([
            cardsStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 30),
            cardsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            cardsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
        
    }
    
    
    private func createLongCardContent(for item: UIView, image: UIImage, title: String, rate: Float, views: Int) -> UIView{
        let carImage = viewService.createCardImage(image: image)
        let cardTitle = viewService.createCardTitle(title: title)
        //        let rateStack = viewService.createRateStack(reate: rate)
        //        let views = viewService.getViewLabel(views: views)
        
        let nextBtn = {
            let btn = UIButton(primaryAction: nil)
            btn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.widthAnchor.constraint(equalToConstant: 18).isActive = true
            btn.heightAnchor.constraint(equalToConstant: 14).isActive = true
            btn.tintColor = .white
            return btn
        }()
        
        
        lazy var topStack = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 12
            stack.alignment = .leading
            stack.addArrangedSubview(carImage)
            stack.addArrangedSubview(cardTitle)
            return stack
        }()
        
        let hStack = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .equalSpacing
            stack.alignment = .center
            stack.addArrangedSubview(nextBtn)
            return stack
        }()
        
        lazy var bottomStack = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 2
            stack.alignment = .leading
            //            stack.addArrangedSubview(rateStack)
            //            stack.addArrangedSubview(views)
            return stack
        }()
        
        let mainStack = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .leading
            stack.spacing = 21
            stack.translatesAutoresizingMaskIntoConstraints = false
            
            stack.addArrangedSubview(topStack)
            stack.addArrangedSubview(bottomStack)
            stack.addArrangedSubview(hStack)
            
            
            return stack
        }()
        
        item.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: item.topAnchor, constant: 25),
            mainStack.leadingAnchor.constraint(equalTo: item.leadingAnchor, constant: 25),
            mainStack.trailingAnchor.constraint(equalTo: item.trailingAnchor, constant: -25),
            mainStack.bottomAnchor.constraint(equalTo: item.bottomAnchor, constant: -27),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        item.addGestureRecognizer(tapGesture)
        item.isUserInteractionEnabled = true
        item.tag = title.hashValue
        return item
        
    }
    
    private func createShortCardContent(for item: UIView, image: UIImage, title: String) -> UIView{
        
        let cardImage = viewService.createCardImage(image: image)
        let cardTitle = viewService.createCardTitle(title: title)
        
        let nextBtn = {
            let btn = UIButton(primaryAction: nil)
            btn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.widthAnchor.constraint(equalToConstant: 18).isActive = true
            btn.heightAnchor.constraint(equalToConstant: 14).isActive = true
            btn.tintColor = .white
            return btn
        }()
        
        
        let hStack = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .equalSpacing
            stack.alignment = .center
            stack.addArrangedSubview(cardImage)
            stack.addArrangedSubview(nextBtn)
            return stack
        }()
        
        let vStack = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 13
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(hStack)
            stack.addArrangedSubview(cardTitle)
            return stack
        }()
        
        item.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: item.topAnchor, constant: 25),
            vStack.leadingAnchor.constraint(equalTo: item.leadingAnchor, constant: 25),
            vStack.trailingAnchor.constraint(equalTo: item.trailingAnchor, constant: -25),
            vStack.bottomAnchor.constraint(equalTo: item.bottomAnchor, constant: -30),
        ])
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        item.addGestureRecognizer(tapGesture)
        item.isUserInteractionEnabled = true
        item.tag = title.hashValue
        
        return item
    }
    
    @objc private func cardTapped(_ sender: UITapGestureRecognizer) {
        guard let card = sender.view else { return }
        
        var cardTitle: String?
        for subview in card.subviews {
            if let stack = subview as? UIStackView {
                for view in stack.arrangedSubviews {
                    if let label = view as? UILabel {
                        cardTitle = label.text
                        break
                    }
                    if let innerStack = view as? UIStackView {
                        for innerView in innerStack.arrangedSubviews {
                            if let label = innerView as? UILabel {
                                cardTitle = label.text
                                break
                            }
                        }
                    }
                }
            }
        }
        
        guard let title = cardTitle else { return }
        
        let cardData: [String: (imageName: String, description: String)] = [
            "Манас": (
                "manasEx",
                """
                Манас эпосу кыргыз элинин улуттук байлыгы, оозеки элдик чыгармачылыктын баалуулугу, дүйнөлүк элдик поэзиянын шедеври. Эпос дүйнөдөгү элдердин эпикалык чыгармаларынын формасы жана мазмуну боюнча эң көлөмдүүсү катары XIX кылымда кеңири коомдук белгилүү болгон. «Манас» эпосу — кыргыз элинин кылымдарды карыткан тарыхынын казынасы. Бул чыгарма элибиздин руханий табылгаларынын алгылыктууларын, басып өткөн тарыхый жолунун орчундуу окуяларын чогултуп, укумдан-тукумга өтүп келген улуу мурасы, улуттук сыймыгы. Манас» эпосу дүйнөдө зор көлөмдүү көркөм чыгарма. Манасчы Саякбай Карала уулунан жазылып алынган эпостун «Манас», «Семетей» жана «Сейтек» үч бөлүмүнүн жалпы көлөмү 500 миң сап ырды түзөт. Бул байыркы гректердин «Иллиадасы» менен «Одиссеясын» бирге кошкон көлөмүнөн 20 эседей көп. «Манастын» ошол бир эле варианты илимде узак убакыт эн көлөмдүү эпос делип келген инди элдеринин «Махабхаратасынан» эки жарым эсе чоң. Жанрдык белгилери боюнча баатырдык эпос катары эсептелген бул чыгарманын мазмуну, берген маалыматтарынын көлөмү боюнча баатырдык эпостордун демейки алкагынан чыгьш, андан алда канча тереңдиги, масштабдуулугу менен айырмаланат.
                """
            ),
            "Жомок": (
                "jomokEx",
                """
                Жомок деген эмне - байыркы замандан эле адам баласы жаратылыш күчтөрүн башкара билүүнү, дүйнөдө болуп жаткандардын бардыгын түшүнүүнү эңсеп, эркин эмгек, адилеттик, бакыт-таалай жөнүндө кыялданган. Мындай үмүт жер шарында жашаган бардык элдер үчүн бирдей мүнөздүү болгон, бирок аны ар бир эл ар түрдүүчө жол менен билдирген. Ушундай үмүттөрдөн, эңсеген тилектерден улам укмуштуудай жомок дүйнөсү пайда болгон. Жомокто элдин көркөм чыгармачылыкка, өзүнүн орошон ой-кыялын туюндурууга болгон умтулуусу ачык көрүнөт. Элдин: жомок апыртманын казынасы, ойдон чыгарылган нерсе - деп айтканы бекеринен эмес. Жомок угармандардан да орошон ой-кыялды, чыгармачылык шыкты талап кылат. Жомоктордогу кыялдануудан пайда болгон окуялардын чындыкка айланып кеткен учурлары да болот.
                
                Мисалы, учуучу машинанын - самолёттун аты сыйкырдуу жомоктон алынганы силерге белгилүү. Мындан жүздөгөн жылдар мурун бир дагы адам жерден көтөрүлүп уча электе, орус жомогунун каарманы - Иван килем-самолёт менен бир топ аралыкка учуп барган. Кыргыз жомокторундагы сыйкырдуу таяк да уч таягым, уч! десе, адамды самаган жерине учуруп барат. Албетте, азыр адам асманга учуп жаткан чыныгы самолёт жомоктогу самолётко же сыйкырдуу таякка окшобойт. Ошондой болсо да адамзаттын асманга учуу жөнүндөгү илгерки тилеги жүзөгө ашты.
                """
            ),
            "Салттар": (
                "saltEx",
                """
                Макал — адамдардын көп жылдан бери келе жаткан философиялык ой корутундуларын жыйынтыктап, алардын турмуш тажрыйбаларынын негизинен алынган, бир же бир нече рифмалашкан жана ритмдешкен сүйлөмдө ойду бүтүрө айткан, тарбиялоо максатында колдонулган фольклордук чыгармалар. «Адам оюнун, акыл-эсинин энциклопедиясы» болгон макалдар дээрлик дүйнөнүн бардык элине таандык болуп саналат, а түгүл айрым макалдардын мааниси окшош келет. Мисалы: «Темир устанын чайыр кесе турган бычагы жок» (вьетнам), «Желпигич сатчу колу менен желпинет» (кытай), «Боёкчунун шымы боёлбойт» (япон), «Карапачынын үйүндө бүтүн идиш жок»(афган), «Кайышчынын камчысы жок» (адыгей). Макалдар элдин турмуш тажрыйбасынан улам чыкканын, алардын жалпы нравалык функциясы бирдей экенин мына ушундан да байкоого болот. Макалдар таптык коомдо таптык мунөзгө ээ болот, башкача айтканда, эзүүчү тап бул же тигил элдик макалдарды өз максатына ылайык бурмалап пайдаланышат. Макалдар фольклордук тексттерде жана бардык эле акын-жазуучулардын чыгармаларында кеңири учурайт жана адам турмушунун бүткүл көрүнүштөрүн өзүнө тема кылып алат.
                """
            ),
            "Макал": (
                "makalEx",
                """
                Макал — адамдардын көп жылдан бери келе жаткан философиялык ой корутундуларын жыйынтыктап, алардын турмуш тажрыйбаларынын негизинен алынган, бир же бир нече рифмалашкан жана ритмдешкен сүйлөмдө ойду бүтүрө айткан, тарбиялоо максатында колдонулган фольклордук чыгармалар. «Адам оюнун, акыл-эсинин энциклопедиясы» болгон макалдар дээрлик дүйнөнүн бардык элине таандык болуп саналат, а түгүл айрым макалдардын мааниси окшош келет. Мисалы: «Темир устанын чайыр кесе турган бычагы жок» (вьетнам), «Желпигич сатчу колу менен желпинет» (кытай), «Боёкчунун шымы боёлбойт» (япон), «Карапачынын үйүндө бүтүн идиш жок»(афган), «Кайышчынын камчысы жок» (адыгей). Макалдар элдин турмуш тажрыйбасынан улам чыкканын, алардын жалпы нравалык функциясы бирдей экенин мына ушундан да байкоого болот. Макалдар таптык коомдо таптык мунөзгө ээ болот, башкача айтканда, эзүүчү тап бул же тигил элдик макалдарды өз максатына ылайык бурмалап пайдаланышат. Макалдар фольклордук тексттерде жана бардык эле акын-жазуучулардын чыгармаларында кеңири учурайт жана адам турмушунун бүткүл көрүнүштөрүн өзүнө тема кылып алат.
                """
            )
        ]
        
        
        guard let data = cardData[title],
              let image = UIImage(named: data.imageName) else {
            return
        }
        
        let detailVC = CardDetailViewController(image: image, description: data.description, cardTitle: cardTitle!)
        controller.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func createService() {
        var headerLabel: UILabel = {
            let label = UILabel()
            label.text = "" // Пустой текст
            label.alpha = 0 // Полностью прозрачный
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.textColor = .white
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        view.addSubview(headerLabel)
        
        let serviceCard: UIView = {
            let card = UIView()
            card.translatesAutoresizingMaskIntoConstraints = false
            card.layer.cornerRadius = 25
            card.layer.cornerCurve = .continuous
            
            let gradient = viewService.gradientLayer(
                startColor: UIColor(hex: "#949AC5FF"),
                frame: CGRect(x: 0, y: 0, width: 400, height: 200)
            )
            card.layer.addSublayer(gradient)
            card.clipsToBounds = true
            
            return card
        }()
        view.addSubview(serviceCard)
        
        let serviceImage: UIImageView = {
            let img = UIImageView()
            img.image = .baner
            img.contentMode = .scaleAspectFill
            img.clipsToBounds = true
            img.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                img.widthAnchor.constraint(equalToConstant: 150),
                img.heightAnchor.constraint(equalToConstant: 150)
            ])
            return img
        }()
        
        let serviceCardTitle = viewService.createCardTitle(title: "Жомоктрор \nДүйнөсүнө сүңгү")
        
        let infoImage: UIImageView = {
            let img = UIImageView()
            img.image = .comp
            img.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                img.widthAnchor.constraint(equalToConstant: 15),
                img.heightAnchor.constraint(equalToConstant: 15)
            ])
            return img
        }()
        
        let infoTitle: UILabel = {
            let title = UILabel()
            title.text = "Чоң ата"
            title.font = UIFont.systemFont(ofSize: 12, weight: .light)
            title.textColor = .white
            return title
        }()
        
        let infoStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .leading
            stack.spacing = 5
            stack.addArrangedSubview(infoImage)
            stack.addArrangedSubview(infoTitle)
            return stack
        }()
        
        let vStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .leading
            stack.spacing = 0  // spacing убираем, управляем вручную через пустые view

            stack.addArrangedSubview(serviceCardTitle)
            
            // Добавляем отступ вниз после заголовка (чтобы поднять его чуть выше)
            let topSpacer = UIView()
            topSpacer.translatesAutoresizingMaskIntoConstraints = false
            topSpacer.heightAnchor.constraint(equalToConstant: 8).isActive = true
            stack.addArrangedSubview(topSpacer)
            
            stack.addArrangedSubview(infoStack)
            
            // Добавляем отступ вниз после infoStack (чтобы infoTitle чуть опустить)
            let bottomSpacer = UIView()
            bottomSpacer.translatesAutoresizingMaskIntoConstraints = false
            bottomSpacer.heightAnchor.constraint(equalToConstant: 4).isActive = true
            stack.addArrangedSubview(bottomSpacer)
            
            return stack
        }()
        
        let hStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .equalSpacing
            stack.alignment = .center
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(serviceImage)
            stack.addArrangedSubview(vStack)
            return stack
        }()
        view.addSubview(hStack)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: cardsStack.bottomAnchor, constant: 40),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            serviceCard.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            serviceCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            serviceCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            hStack.topAnchor.constraint(equalTo: serviceCard.topAnchor, constant: 25),
            hStack.leadingAnchor.constraint(equalTo: serviceCard.leadingAnchor, constant: 25),
            hStack.trailingAnchor.constraint(equalTo: serviceCard.trailingAnchor, constant: -25),
            hStack.bottomAnchor.constraint(equalTo: serviceCard.bottomAnchor, constant: -25),
        ])
    }
}
