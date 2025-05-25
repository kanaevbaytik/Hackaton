
import UIKit

class ViewService{
    static let shared = ViewService()
    private init() {}
    
    
    func gradientLayer(startColor: UIColor?, endColor: UIColor? = UIColor(hex: "#565C87FF"), frame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200)) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [
            (startColor ?? .white).resolvedColor(with: UITraitCollection.current).cgColor,
            (endColor ?? .white).resolvedColor(with: UITraitCollection.current).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.locations = [-0.3, 0.3]
        return gradient
    }

    
    func createCardView(gradientColor: String, width w: CGFloat) -> UIView{
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.widthAnchor.constraint(equalToConstant: w).isActive = true
        card.layer.cornerRadius = 25
        card.layer.cornerCurve = .continuous
        
        let gradient = gradientLayer(startColor: UIColor(hex: gradientColor))
        card.layer.addSublayer(gradient)
        
        card.clipsToBounds = true
        return card
        
    }
    
    func createCardImage(image: UIImage) -> UIImageView{
        let img = UIImageView()
        img.image = image
        img.translatesAutoresizingMaskIntoConstraints = false
        
        img.widthAnchor.constraint(equalToConstant: 27).isActive = true
        img.heightAnchor.constraint(equalToConstant: 27).isActive = true
        
        
        return img
        
    }
    
    func createCardTitle(title: String) -> UILabel{
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }
    
    
    func createRateStack(reate: Float) -> UIStackView{
        let rateStack = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .center
            stack.spacing = 5
            return stack
        }()
        
        
        //STAR
        let rateImg = UIImageView()
        rateImg.image = UIImage(systemName: "star.fill")
        rateImg.translatesAutoresizingMaskIntoConstraints = false
        rateImg.widthAnchor.constraint(equalToConstant: 10).isActive = true
        rateImg.heightAnchor.constraint(equalToConstant: 10).isActive = true
        rateImg.tintColor = .white
        
        //RATE
        let rateLabel = UILabel()
        rateLabel.text = "\(reate)"
        rateLabel.textColor = .white
        rateLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        
        rateStack.addArrangedSubview(rateImg)
        rateStack.addArrangedSubview(rateLabel)
        return rateStack
    }
    
    func getViewLabel(views: Int) -> UILabel{
        let label = UILabel()
        label.text = "\(views) views"
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = .white
        return label
    }
    
    
    func getSideStack(items: [UIView]) -> UIStackView{
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 17
        //stack.alignment = .fill
        
        items.forEach{
            stack.addArrangedSubview($0)
        }
        
        return stack
    }
    
}
