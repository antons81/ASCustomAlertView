//
//  FLWCustomButton.swift
//  FloorWatch
//
//  Created by Anton Stremovskiy on 6/12/17.
//  Copyright © 2017 Softermii. All rights reserved.
//

import UIKit

public class AlertButton : UIButton {
    
    var action: (() -> Void)? = nil
    var closeAction: (() -> Void)?

    static public var backColor           = UIColor.clear
    static public var isDismissable: Bool = true
    
    public static var okButton: AlertButton = { return  AlertButton(title: "OK") }()
    public static var cancelButton: AlertButton = { return AlertButton(title: "Cancel") }()


    init(title: String = "OK") {
        super.init(frame:.zero)
        localInit(title: title)
    }
    
    convenience init(title: String? = "OK", backColor: UIColor? = AlertButton.backColor, textColor: UIColor? = .white) {
        self.init()
        backgroundColor = backColor
        setAttributedTitle(NSMutableAttributedString.b2(string: title), for: .normal)
        actionInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init( coder:aDecoder )
        localInit()
    }
    
    private func actionInit() {
        addTarget(self, action:#selector(AlertButton.buttonTapped(_:)), for:.touchUpInside)
    }

    
    private func localInit(title: String = "OK") {
        backgroundColor = AlertButton.backColor
        setAttributedTitle(NSMutableAttributedString.b1(string: title), for: .normal)
        actionInit()
    }
    
    @objc fileprivate func buttonTapped(_ btn: AlertButton) {
        if AlertButton.isDismissable || action == nil {
           closeAction?()
        }

        action?()
    }
}

