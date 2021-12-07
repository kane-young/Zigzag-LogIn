//
//  LogInViewController.swift
//  Kane-Login
//
//  Created by 이영우 on 2021/12/06.
//

import UIKit

class LogInViewController: UIViewController {

    static let identifier: String = "LogInViewController"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var autoLogInAgreeLabel: UILabel!
    @IBOutlet weak var autoLogInCheckButton: UIButton!

    private var ispressed: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabels()
        configureNavigationBar()
    }

    private func configureNavigationBar() {
        self.navigationItem.title = "로그인(꽃피는시절)"
    }

    private func configureLabels() {
        titleLabel.adjustsFontSizeToFitWidth = true
        subTitleLabel.adjustsFontSizeToFitWidth = true
        guard let autoLogInAgreeText = autoLogInAgreeLabel.text else { return }
        let attributedText = NSMutableAttributedString(string: autoLogInAgreeText)
        attributedText.addAttribute(.foregroundColor, value: UIColor.systemPink,
                                   range: (autoLogInAgreeText as NSString).range(of: "자동 로그인 약관"))
        autoLogInAgreeLabel.attributedText = attributedText
    }

    @IBAction func touchAutoLogInButton(sender: UIButton) {
        autoLogInCheckButton.configurationUpdateHandler = { button in
            var image = button.configuration?.background.image
            if button.state == .normal {
                if self.ispressed {
                    image = UIImage(named: "unchecked_normal")
                    self.ispressed = false
                } else {
                    image = UIImage(named: "checked_normal")
                    self.ispressed = true
                }
            } else if button.state == .highlighted {
                if self.ispressed {
                    image = UIImage(named: "checked_pressed")
                } else {
                    image = UIImage(named: "unchecked_pressed")
                }
            }
            button.configuration?.background.image = image
        }
    }
}
