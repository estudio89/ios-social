//
//  TwitterButton.swift
//  compreconfie
//
//  Created by Luccas Correa on 4/12/16.
//  Copyright © 2016 Estúdio 89. All rights reserved.
//

import Foundation
import UIKit

class TwitterButton: SocialButton {
    var logInCompletion: ((session: TWTRSession?, error:NSError?) -> Void)?
    var loginMethods: [TWTRLoginMethod]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(onClick), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(onClick), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func onClick() {
        Twitter.sharedInstance().logInWithMethods(loginMethods![0], completion: logInCompletion!)
    }
    
    override func getColor() -> UIColor {
        return UIColor(hex: 0x48A7F2)
    }
}