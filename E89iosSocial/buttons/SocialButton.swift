//
//  SocialButton.swift
//  compreconfie
//
//  Created by Luccas Correa on 4/12/16.
//  Copyright © 2016 Estúdio 89. All rights reserved.
//

import Foundation
import UIKit

class SocialButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func getColor() -> UIColor {
        return UIColor.clearColor()
    }
    
    func getImage() -> UIImage? {
        return UIImage(named: "RefreshIcon")
    }
    
    func getText() -> String {
        return "Facebook"
    }
    
    func configure() {
        // Border
        let border = UIView()
        border.backgroundColor = getColor()
        border.translatesAutoresizingMaskIntoConstraints = false
        addSubview(border)
        
        
        let vBorderConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[border]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["border" : border])
        let heightBorderConstraint = NSLayoutConstraint.init(item: border, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        let widthBorderConstraint = NSLayoutConstraint.init(
            item: border, attribute: .Width, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 5)
        border.addConstraint(widthBorderConstraint)
        self.addConstraint(heightBorderConstraint)
        self.addConstraints(vBorderConstraints)
        
        // Icon
        let icon = UIImageView(image: getImage()?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
        icon.tintColor = getColor()
        icon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(icon)
        
        let widthIconConstraint = NSLayoutConstraint.init(
            item: icon, attribute: .Width, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20)
        let heightIconConstraint = NSLayoutConstraint.init(
            item: icon, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20)
        icon.addConstraints([widthIconConstraint, heightIconConstraint])
        
        let vIconConstraint: NSLayoutConstraint = NSLayoutConstraint.init(item: icon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        self.addConstraint(vIconConstraint)
        
        // Text
        self.titleLabel?.removeFromSuperview()
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = getColor()
        label.text = self.titleLabel?.text
        label.font = UIFont.boldSystemFontOfSize(15)
        
        
        let vLabelConstraint: NSLayoutConstraint = NSLayoutConstraint.init(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        
        let heightLabelConstraint = NSLayoutConstraint.init(
            item: label, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20)
        
        label.addConstraint(heightLabelConstraint)
        addSubview(label)
        
        self.addConstraint(vLabelConstraint)
        
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[border]-10-[icon]-5-[label]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["border" : border, "icon": icon, "label":label])
        
        self.addConstraints(hConstraints)
        
        
        
    }
}