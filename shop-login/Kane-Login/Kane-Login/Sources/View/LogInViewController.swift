//
//  LogInViewController.swift
//  Kane-Login
//
//  Created by 이영우 on 2021/12/06.
//

import UIKit

class LogInViewController: UIViewController {

    static let identifier: String = "LogInViewController"
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var subInformationLabel: UILabel!
    @IBOutlet weak var autoLogInAgreeLabel: UILabel!
    @IBOutlet weak var autoLogInCheckButton: UIButton!
    @IBOutlet weak var identityTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewsView: UIView!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var logInButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var findButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordBottomConstraint: NSLayoutConstraint!

    private var ispressed = false
    private var viewModel = LogInViewModel(validator: LogInValidator())

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelBind()
        configureLabels()
        configureNavigationBar()
        configureTextFields()
        distinguishAutoLogIn()
    }

    private func configureNavigationBar() {
        self.navigationItem.title = "로그인(꽃피는시절)"
    }

    private func configureLabels() {
        configureInformationLabels()
        configureAutoLogInAgreeLabel()
    }

    private func configureInformationLabels() {
        informationLabel.adjustsFontSizeToFitWidth = true
        subInformationLabel.adjustsFontSizeToFitWidth = true
    }

    private func configureAutoLogInAgreeLabel() {
        guard let autoLogInAgreeText = autoLogInAgreeLabel.text else { return }
        let attributedText = NSMutableAttributedString(string: autoLogInAgreeText)
        attributedText.addAttribute(.foregroundColor, value: UIColor.systemPink,
                                   range: (autoLogInAgreeText as NSString).range(of: "자동 로그인 약관"))
        autoLogInAgreeLabel.attributedText = attributedText
    }

    @IBAction func touchAutoLogInButton(sender: UIButton) {
        sender.configurationUpdateHandler = { button in
            var image = button.configuration?.background.image
            image = self.autoLogInAgreeButtonImage()
            button.configuration?.background.image = image
        }
    }

    private func autoLogInAgreeButtonImage() -> UIImage? {
        if autoLogInCheckButton.state == .normal && ispressed {
            self.ispressed = false
            return UIImage(named: "unchecked_normal")
        } else if autoLogInCheckButton.state == .normal && !ispressed {
            self.ispressed = true
            return UIImage(named: "checked_normal")
        } else if autoLogInCheckButton.state == .highlighted && ispressed {
            return UIImage(named: "checked_pressed")
        } else if autoLogInCheckButton.state == .highlighted && !ispressed {
            return UIImage(named: "unchecked_pressed")
        }
        return nil
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

    private func configureTextFields() {
        configureTextFieldAppearance(identityTextField)
        configureTextFieldAppearance(passwordTextField)
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
        if ispressed {
            UserDefaults.standard.set(true, forKey: "AutoLogIn")
        }
        subInformationLabel.isHidden = true
        informationLabel.text = "로그인 중입니다..."
        setViewsDisabled()
        sender.setTitle("", for: .normal)
        sender.configuration?.showsActivityIndicator = true
        DispatchQueue.global().async {
            sleep(5)
            DispatchQueue.main.async {
                self.informationLabel.text = "로그인 성공!"
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
        findButton.isEnabled = false
        identityTextField.isEnabled = false
        passwordTextField.isEnabled = false
        autoLogInAgreeLabel.isEnabled = false
        autoLogInCheckButton.isEnabled = false
    }

    private func setViewsOpacity() {
        logInButton.layer.opacity = 0.5
        findButton.layer.opacity = 0.5
        identityTextField.layer.opacity = 0.5
        passwordTextField.layer.opacity = 0.5
        autoLogInAgreeLabel.layer.opacity = 0.5
        autoLogInCheckButton.layer.opacity = 0.5
    }

    private func distinguishAutoLogIn() {
        let isAgreed = UserDefaults.standard.bool(forKey: "AutoLogIn")
        if isAgreed == true {
            let autoLogInTermsButton = UIButton()
            autoLogInTermsButton.setTitle("자동 로그인 연결 약관", for: .normal)
            autoLogInTermsButton.backgroundColor = .systemGray4
            autoLogInTermsButton.setTitleColor(.darkGray, for: .normal)
            autoLogInTermsButton.translatesAutoresizingMaskIntoConstraints = false
            scrollViewsView.addSubview(autoLogInTermsButton)
            autoLogInAgreeLabel.isHidden = true
            autoLogInCheckButton.isHidden = true
            logInButtonTopConstraint.isActive = false
            passwordBottomConstraint.isActive = false
            findButtonBottomConstraint.isActive = false
            NSLayoutConstraint.activate([
                logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
                findButton.bottomAnchor.constraint(equalTo: autoLogInTermsButton.topAnchor),
                autoLogInTermsButton.heightAnchor.constraint(equalToConstant: 50),
                autoLogInTermsButton.leadingAnchor.constraint(equalTo: scrollViewsView.leadingAnchor),
                autoLogInTermsButton.trailingAnchor.constraint(equalTo: scrollViewsView.trailingAnchor),
                autoLogInTermsButton.bottomAnchor.constraint(equalTo: scrollViewsView.bottomAnchor)
            ])
        }
    }
}
