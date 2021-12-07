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
    @IBOutlet weak var identityTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var findingButton: UIButton!

    private var ispressed = false
    private var viewModel = LogInViewModel(validator: LogInValidator())

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelBind()
        configureLabels()
        configureNavigationBar()
        configureTextFieldAppearance(identityTextField)
        configureTextFieldAppearance(passwordTextField)
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
        sender.configurationUpdateHandler = { button in
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

    private func viewModelBind() {
        viewModel.identity.bind { [weak self] textState in
            let color = self?.textFieldColor(with: textState)
            self?.identityTextField.layer.borderColor = color
        }
        viewModel.password.bind { [weak self] textState in
            let color = self?.textFieldColor(with: textState)
            self?.passwordTextField.layer.borderColor = color
        }
        viewModel.validatedAll.bind { [weak self] validated in
            self?.logInButton.isEnabled = validated
        }
    }

    private func configureTextFieldAppearance(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemBackground.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 15
    }

    private func textFieldColor(with textState: TextState) -> CGColor {
        switch textState {
        case .empty:
            return UIColor.systemBackground.cgColor
        case .valid:
            return UIColor.systemGreen.cgColor
        case .invalid:
            return UIColor.systemRed.cgColor
        }
    }

    @IBAction func touchLogInButton(sender: UIButton) {
        sender.setTitle(nil, for: .normal)
        setViewsDisabled()
        sender.setTitle(nil, for: .normal)
        titleLabel.text = "로그인 중입니다..."
        subTitleLabel.isHidden = true
        sender.configuration?.showsActivityIndicator = true
        DispatchQueue.global().async {
            sleep(5)
            DispatchQueue.main.async {
                sender.configuration?.showsActivityIndicator = false
            }
        }
    }

    @IBAction func editIdentityTextField(_ sender: LogInTextField) {
        viewModel.textChanged(sender.text, type: .identity)
    }

    @IBAction func editPasswordTextField(_ sender: LogInTextField) {
        viewModel.textChanged(sender.text, type: .password)
    }

    private func setViewsDisabled() {
        logInButton.isEnabled = false
        findingButton.isEnabled = false
        identityTextField.isEnabled = false
        passwordTextField.isEnabled = false
        autoLogInAgreeLabel.isEnabled = false
        autoLogInCheckButton.isEnabled = false
    }
}
