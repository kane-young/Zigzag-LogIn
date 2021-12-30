//
//  LogInTextField.swift
//  Kane-Login
//
//  Created by 이영우 on 2021/12/05.
//

import UIKit

@IBDesignable
final class LogInTextField: UITextField {
    @IBInspectable
    var leftPadding: CGFloat = 0

    @IBInspectable
    var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }

    @IBInspectable
    var underlineColor: UIColor?

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let underlineColor = underlineColor {
            let path = UIBezierPath()
            path.lineWidth = 0.3
            path.move(to: CGPoint(x: 0, y: bounds.height - 1))
            path.addLine(to: CGPoint(x: bounds.width, y: bounds.height - 1))
            underlineColor.set()
            path.close()
            path.stroke()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBorderAttributes()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureBorderAttributes()
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }

    private func configureBorderAttributes() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemBackground.cgColor
    }

    private func updateView() {
        if let image = leftImage {
            self.leftViewMode = .always
            let size = bounds.height - 10
            let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size + 10, height: size))
            let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
            iconView.contentMode = .scaleAspectFit
            iconView.layer.cornerRadius = size / 2
            iconView.image = image
            iconView.clipsToBounds = true
            outerView.addSubview(iconView)
            self.leftView = outerView
        } else {
            self.leftViewMode = .never
            self.leftView = nil
        }
    }
}
