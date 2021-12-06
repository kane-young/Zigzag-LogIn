//
//  LogInTextField.swift
//  Kane-Login
//
//  Created by 이영우 on 2021/12/05.
//

import UIKit

@IBDesignable
class LogInTextField: UITextField {
    @IBInspectable
    var leftImage: UIImage? {
        didSet {
            if leftImage == nil {
                self.leftViewMode = .never
            } else {
                self.leftViewMode = .always
            }
            let size = self.bounds.width / 14
            let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size + 10, height: size))
            let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
            iconView.contentMode = .scaleAspectFit
            iconView.layer.cornerRadius = size / 2
            iconView.image = leftImage
            iconView.clipsToBounds = true
            outerView.addSubview(iconView)
            self.leftView = outerView
        }
    }

    @IBInspectable
    var underlineColor: UIColor = .systemGray {
        didSet {
            let border = CALayer()
            border.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.width, height: 0.3)
            border.borderWidth = 0.1
            border.backgroundColor = underlineColor.cgColor
            self.layer.addSublayer(border)
        }
    }
}
