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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabels()
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
}
