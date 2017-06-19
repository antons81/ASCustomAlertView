//
//  Utils.swift
//  CustomAlertController
//
//  Created by Anton Stremovskiy on 6/16/17.
//  Copyright © 2017 áSoft. All rights reserved.
//

import Foundation
import UIKit



extension UIViewController {
    
    func showSuccessAlert(with title: String, message: String, buttons: [(String, (Void) -> Void)]?) {
        let vc = AlertController.makeAlert(title: title, message: message, buttons: buttons, labels: [title, message])
        
        springAnimation(with: (view.window?.layer)!)
        
        self.present(vc, animated: false) {
            self.view.layer.removeAllAnimations()
        }
    }
    
    
    func springAnimation(with layer: CALayer) {
        let spring = CASpringAnimation(keyPath: "position.x")
        spring.damping = 2
        spring.initialVelocity = 50
        spring.fromValue = (view.window?.layer.position.x)! - 2
        spring.toValue = view.window?.layer.position.x
        spring.duration = spring.settlingDuration
        layer.add(spring, forKey: "rotate")
    }
   
}

class AlertController: UIViewController {
    
    @IBOutlet weak var buttonsStack: UIStackView!
    @IBOutlet weak var labelsStack: UIStackView!
    @IBOutlet var containerView: UIView!
    
    private var controls:[UIView] = [UIView]()
    
    convenience init() {
        self.init(nibName: String.init(describing: AlertController.self), bundle: Bundle.main)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    override func loadView() {
        super.loadView()
        internalLoadViews()
    }
    
    private func internalLoadViews() {
        self.containerView.clipsToBounds = true
        
        controls.forEach { element in
            switch element {
            case let x where element is UILabel:
                labelsStack.addArrangedSubview(x)
            case let x where element is AlertButton:
                 buttonsStack.addArrangedSubview(x)
            default:
                break
            }
        }
        
               
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    static public func makeAlert(title: String?, message: String?, buttons: [(String, (Void) -> Void)]?, labels: [String]) -> AlertController {
        let alert = AlertController()
        
        guard let b = buttons else { return alert }
        b.forEach { alert.controls.append(getButton(text: $0.0, action: $0.1)) }
        labels.forEach { alert.controls.append(getLabel(text: setAttributedText(text: $0))) }
        
        return alert
    }
    
    @discardableResult
    static func getButton(text: String, action: @escaping () -> Void) -> AlertButton {
        let button = AlertButton()
        button.setTitle(text, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.blue
        button.setTitleColor(UIColor.white, for: .normal)
        button.action = action
        button.frame = CGRect(x: button.frame.origin.x, y: button.frame.origin.x, width: 100, height: 44)
        button.setNeedsLayout()
        button.layoutIfNeeded()
        
        return button
    }
    
    static private func setAttributedText (text: String) -> NSAttributedString {
        let attributes = [NSFontAttributeName : UIFont.init(name: "Verdana", size: 15), NSForegroundColorAttributeName: UIColor.darkGray]
        return NSAttributedString.init(string: text, attributes: attributes as! [String : NSObject])
    }
    
    
    static func getLabel(text: NSAttributedString) -> UILabel {
        let label = UILabel()
        label.attributedText = text
        return label
    }

}


