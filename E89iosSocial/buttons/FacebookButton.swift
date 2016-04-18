//
//  FacebookButton.swift
//  compreconfie
//
//  Created by Luccas Correa on 4/12/16.
//  Copyright © 2016 Estúdio 89. All rights reserved.
//

import Foundation
import UIKit

protocol FacebookButtonDelegate {
    func loginButton(loginButton: FacebookButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
}

class FacebookButton: SocialButton {
    var delegate: FacebookButtonDelegate?
    var readPermissions:[String]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(onClick), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(onClick), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func onClick() {
        let login: FBSDKLoginManager = FBSDKLoginManager()
        login.logInWithReadPermissions(readPermissions!, handler: {
            (result: FBSDKLoginManagerLoginResult!, error: NSError!) in
            self.delegate?.loginButton(self, didCompleteWithResult: result, error: error)
        })
        
    }
    
    override func getColor() -> UIColor {
        return UIColor(hex: 0x3A4DB5)
    }
}