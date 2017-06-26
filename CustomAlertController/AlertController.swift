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
    func presentAlertController(controller: AlertController) {
        
        self.present(controller, animated: false) {
            self.parent?.modalTransitionStyle = .coverVertical
            
            UIView.animate(withDuration: AlertController.animationDuration, animations: { _ in
                
                controller.containerView.backgroundColor = UIColor.asWhite
                controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
                //if animation {
                //    self?.setupSpringAnimation(with: (controller.containerView.layer))
                //}
                
                }, completion: { (success) in
                    debugPrint("animation completed")
            })
        }
    }
    
    func showErrorAlert(with title: String, message: String, image: UIImage?, buttonsLayout: UILayoutConstraintAxis, buttons: [(String, isDismissable: Bool, (Void) -> Void)]?) {
        let vc = AlertController.makeAlert(title: title, message: message, image: image, buttonsLayout: buttonsLayout, buttons: buttons, labels: [title, message])
        presentAlertController(controller: vc)
    }
    
    func showSuccessAlert(with title: String, message: String, image: UIImage?, buttonsLayout: UILayoutConstraintAxis, buttons: [UIButton]?) {
        let vc = AlertController.makeAlertWith(image: image, buttons: buttons, buttonsLayout: buttonsLayout, labels: [title, message])
        presentAlertController(controller: vc)
    }

    func setupSpringAnimation(with layer: CALayer) {
        let anim = CASpringAnimation(keyPath: "transform.rotation")
        anim.fromValue = 0.3
        anim.toValue = 0
        anim.damping = 5
        anim.speed = 3
        anim.initialVelocity = 10
        anim.duration = 1
        layer.add(anim, forKey: "mySpring")
    }
    
}


class AlertController: UIViewController {
    
    @IBOutlet weak var buttonsStack: UIStackView!
    @IBOutlet weak var labelsStack: UIStackView!
    @IBOutlet var containerView: UIView!
    
    private var controls:[UIView] = [UIView]()
    
    var buttonsLayout: UILayoutConstraintAxis = .horizontal
    
    static public var alertCornerRadius = CGFloat(4)
    static public var animationDuration = TimeInterval(0.2)
    static public var maximumImageHeight = CGFloat(80)
    
    
    convenience init() {
        self.init(nibName: String.init(describing: AlertController.self), bundle: Bundle.main)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
    }
    
    convenience init(layout: UILayoutConstraintAxis) {
        self.init(nibName: String.init(describing: AlertController.self), bundle: Bundle.main)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
        buttonsLayout = layout
    }

    override func loadView() {
        super.loadView()
     
        internalLoadViews()
    }
    
    private func internalLoadViews() {
        containerView.clipsToBounds = true
        
        controls.forEach { element in
            switch element {
            case let x where element is UIImageView:
                labelsStack.addArrangedSubview(x)
            case let x where element is UILabel:
                labelsStack.addArrangedSubview(x)
            case let x where element is AlertButton:
                 buttonsStack.addArrangedSubview(x)
            case let x where element is UIButton:
                 buttonsStack.addArrangedSubview(x)
            default:
                break
            }
        }
        
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        switch buttonsLayout {
        case _ where buttonsLayout == .vertical:
            self.buttonsStack.axis = .vertical
            self.buttonsStack.alignment = .fill
            self.buttonsStack.distribution = .fillEqually
            self.buttonsStack.spacing = 10
        default:
            break
        }
        
        containerView.layer.cornerRadius = AlertController.alertCornerRadius
        containerView.clipsToBounds = true
    }
    
    static public func makeAlert(title: String?,
                                 message: String?,
                                 image: UIImage?,
                                 buttonsLayout: UILayoutConstraintAxis,
                                 buttons: [(String, isDismissable: Bool, (Void) -> Void)]?,
                                 labels: [String]) -> AlertController {
        
        let alert = AlertController(layout: buttonsLayout)

        guard let buttons = buttons else { return alert }
        buttons.forEach { alert.controls.append(alert.getButton(text: $0.0, isDismissable: $0.isDismissable, action: $0.2)) }
        if let image = image { alert.controls.append(getImage(image: image)) }
        labels.forEach { alert.controls.append(getLabel(text: setAttributedText(text: $0))) }

        return alert
    }
    
    
    static public func makeAlertWith(image: UIImage?,
                                 buttons: [UIButton]?,
                                 buttonsLayout: UILayoutConstraintAxis,
                                 labels: [String]) -> AlertController {
        
        let alert = AlertController(layout: buttonsLayout)
        
        guard let buttons = buttons else { return alert }
        setupAlertWith(alert: alert, image: image, labels: labels, buttons: buttons)
        return alert
    }
    
    static func setupAlertWith(alert: AlertController, image: UIImage?, labels: [String], buttons: [UIButton]) {
        buttons.forEach { (button: UIButton) in alert.controls.append(button) }
        if let image = image { alert.controls.append(getImage(image: image)) }
        labels.forEach { alert.controls.append(getLabel(text: setAttributedText(text: $0))) }
    }

    
    @discardableResult
    func getButton(text: String,
                   isDismissable: Bool = false,
                   action: @escaping () -> Void) -> AlertButton {
        
        let button = AlertButton()
        button.setTitle(text, for: .normal)
        button.layer.cornerRadius = 4
        button.isDismissable = isDismissable
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.asCoolBlue
        button.setTitleColor(UIColor.asWhite, for: .normal)
        button.action = action
        
        let closeAction = {
            self.dismiss(animated: false, completion: {
                UIView.animate(withDuration: AlertController.animationDuration, animations: { _ in
                    self.view.backgroundColor = UIColor.white.withAlphaComponent(1)
                })
            })
        }
        
        button.closeAction = closeAction
        button.frame = CGRect(x: button.frame.origin.x, y: button.frame.origin.x, width: 100, height: 50)
        button.setNeedsLayout()
        button.layoutIfNeeded()
        
        return button
    }

    static func getLabel(text: NSAttributedString) -> UILabel {
        let label = UILabel()
        label.attributedText = text
        return label
    }
    
    static func getImage(image: UIImage) -> UIImageView {
        guard let img = image.resizeImageWith(newSize: CGSize(width: 100, height: 100)) else { return UIImageView(image: image) }
        let imageView = UIImageView(image: img)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    
    static private func setAttributedText (text: String) -> NSAttributedString {
        let attributes = [NSFontAttributeName : UIFont.init(name: "Verdana", size: 15), NSForegroundColorAttributeName: UIColor.darkGray]
        return NSAttributedString.init(string: text, attributes: attributes as! [String : NSObject])
    }
    

    /*static private func dismissAlertController() {
        self.dismiss(animated: false) {
            UIView.animate(withDuration: 0.2, animations: { _ in
                self.view.backgroundColor = UIColor.white.withAlphaComponent(1)
            })
        }
    }*/

}

extension UIImage {
    
    func resizeImageWith(newSize: CGSize) -> UIImage? {
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}



