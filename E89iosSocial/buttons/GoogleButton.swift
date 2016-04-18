//
//  GoogleButton.swift
//  compreconfie
//
//  Created by Luccas Correa on 4/12/16.
//  Copyright © 2016 Estúdio 89. All rights reserved.
//

import Foundation
import UIKit

class GoogleButton: SocialButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(onClick), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(onClick), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func onClick() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func getColor() -> UIColor {
        return UIColor(hex: 0xD80A24)
    }
}