//
//  Extension+UIViewController.swift
//  FloorWatch
//
//  Created by Anton Stremovskiy on 7/3/17.
//  Copyright © 2017 Softermii. All rights reserved.
//

import Foundation
import UIKit


public extension UIViewController {
    
    public func presentAlertController(controller: AlertController) {
        self.present(controller, animated: true) {
            self.parent?.modalTransitionStyle = .coverVertical
            
            UIView.animate(withDuration: AlertController.animationDuration, animations: { _ in
                controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                //controller.setupSpringAnimation(with: controller.containerView.layer) //TODO
            }, completion: { (success) in
                //debugPrint("animation completed")
            })
        }
    }
    
    public func presentPopUp(with title: NSAttributedString,
                      message: NSAttributedString, image: UIImage?,
                      buttonsLayout: UILayoutConstraintAxis,
                      buttons: [AlertButton]?) {
        
        let vc = AlertController.showWarningAlert(with: title,
                                                  message: message,
                                                  image: image,
                                                  buttonsLayout: buttonsLayout,
                                                  buttons: buttons,
                                                  labels: [title, message])
        presentAlertController(controller: vc)
    }
    
    public func presentInputPopUp(with title: NSAttributedString,
                           message: NSAttributedString,
                           image: UIImage?,
                           buttonsLayout: UILayoutConstraintAxis,
                           buttons: [AlertButton]?,
                           textFields: [AlertTextField]?) {
        
        let vc = AlertController.showInputAlert(with: title,
                                                message: message,
                                                image: image,
                                                buttonsLayout: buttonsLayout,
                                                buttons: buttons,
                                                labels: [title, message],
                                                textFields: textFields)
        presentAlertController(controller: vc)
    }
    
    
    public func presentRatingPopUp(with title: NSAttributedString,
                           image: UIImage?,
                           buttonsLayout: UILayoutConstraintAxis,
                           buttons: [AlertButton]?,
                           rating: RatingView?,
                           textFields: [AlertTextField]?) {
        
        let vc = AlertController.showRatingAlert(with: title,
                                                image: image,
                                                buttonsLayout: buttonsLayout,
                                                buttons: buttons,
                                                rating: rating,
                                                textFields: textFields)
        presentAlertController(controller: vc)
    }

    
    
    //MARK: - TODO: future iterations
    
   public func setupSpringAnimation(with layer: CALayer) {
        let anim             = CASpringAnimation(keyPath: "transform.rotation")
        anim.fromValue       = 0.3
        anim.toValue         = 0
        anim.damping         = 5
        anim.speed           = 3
        anim.initialVelocity = 10
        anim.duration        = 1
        layer.add(anim, forKey: "mySpring")
    }
    
}


public extension NSObject {
    
    var className: String {
        return NSStringFromClass(self as! AnyClass).components(separatedBy: ".").last ?? ""
    }
    
    public class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}

