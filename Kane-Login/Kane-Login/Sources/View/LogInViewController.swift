//
//  LogInViewController.swift
//  Kane-Login
//
//  Created by 이영우 on 2021/12/06.
//

import UIKit

final class LogInViewController: UIViewController {
    static let identifier: String = "LogInViewController"

    @IBOutlet private var informationLabel: UILabel!
    @IBOutlet private var subInformationLabel: UILabel!
    @IBOutlet private var autoLogInAgreeLabel: UILabel!
    @IBOutlet private var autoLogInCheckButton: UIButton!
    @IBOutlet private var identityTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var scrollViewContentView: UIView!
    @IBOutlet private var logInButton: UIButton!
    @IBOutlet private var findButton: UIButton!
    @IBOutlet private var logInButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet private var findButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var passwordBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var scrollViewBottomConstraint: NSLayoutConstraint!
    private lazy var autoLogInTermsButton: UIButton = {
        let autoLogInTermsButton = UIButton()
        autoLogInTermsButton.setTitle(Style.AutoLogInTermsButton.title, for: .normal)
        autoLogInTermsButton.backgroundColor = .systemGray4
        autoLogInTermsButton.setTitleColor(.darkGray, for: .normal)
        autoLogInTermsButton.translatesAutoresizingMaskIntoConstraints = false
        return autoLogInTermsButton
    }()

    private var viewModel = LogInViewModel(validator: LogInValidator())
    weak var delegate: LogInViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabels()
        configureNavigationBar()
        distinguishAutoLogIn()
        addTapGestureRecognizer()
        configureScrollViewConstraints()
        viewModelBind()
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

    private func textFieldColor(with textState: TextState) -> CGColor {
        switch textState {
        case .empty:
            return Style.TextFieldColor.empty
        case .valid:
            return Style.TextFieldColor.valid
        case .invalid:
            return Style.TextFieldColor.invalid
        }
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
        let range = (autoLogInAgreeText as NSString).range(of: Style.AutoLogInAgreeLabel.textForAttributed)
        attributedText.addAttribute(.foregroundColor, value: UIColor.systemPink, range: range)
        autoLogInAgreeLabel.attributedText = attributedText
    }

    private func configureScrollViewConstraints() {
        scrollViewBottomConstraint.isActive = false
        scrollViewBottomConstraint = view.keyboardLayoutGuide.topAnchor.constraint(equalTo: scrollView.frameLayoutGuide.bottomAnchor)
        scrollViewBottomConstraint.isActive = true
    }

    private func configureNavigationBar() {
        self.navigationItem.title = Style.Navigation.title
    }

    private func distinguishAutoLogIn() {
        if viewModel.isAgreed {
            deActivateConstraints()
            hideAutoLogInAgreeViews()
            setUpAutoLogInTermsButton()
        }
    }

    @IBAction private func touchAutoLogInButton(sender: UIButton) {
        if viewModel.isAgreed {
            sender.setImage(UIImage(named: Style.AutoLogInAgreeButton.uncheckedNormal), for: .normal)
            sender.setImage(UIImage(named: Style.AutoLogInAgreeButton.uncheckedHighlighted), for: .highlighted)
        } else {
            sender.setImage(UIImage(named: Style.AutoLogInAgreeButton.checkedNormal), for: .normal)
            sender.setImage(UIImage(named: Style.AutoLogInAgreeButton.checkedHighlighted), for: .highlighted)
        }
        viewModel.changeAutoLogInAgreement()
    }

    @IBAction private func touchLogInButton(sender: UIButton) {
        if viewModel.isAgreed && viewModel.password.value == .valid && viewModel.identity.value == .valid {
            UserDefaults.standard.set(true, forKey: UserDefaults.Key.isAutoLogIn)
            changeViewsForLogIn()
            progressLogIn()
        } else {
            alertAutoLogInRequest()
        }
    }

    private func changeViewsForLogIn() {
        subInformationLabel.isHidden = true
        informationLabel.text = Style.InformationText.progress
        changeLogInButtonForLogIn()
        setViewsDisabled()
        setViewsOpacity()
    }

    private func progressLogIn() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 5.0) { [weak self] in
            DispatchQueue.main.async {
                self?.backToMainViewController()
            }
        }
    }

    private func backToMainViewController() {
        informationLabel.text = Style.InformationText.success
        guard let identity = identityTextField.text else { return }
        delegate?.didSuccessLogIn(identity: identity)
        navigationController?.popViewController(animated: true)
    }

    private func changeLogInButtonForLogIn() {
        if #available(iOS 15.0, *) {
            logInButton.configuration?.showsActivityIndicator = true
            logInButton.setTitle(Style.LogInButtonTitle.progress, for: .normal)
        }
    }

    @IBAction private func editIdentityTextField(_ sender: UITextField) {
        viewModel.textChanged(sender.text, type: .identity)
    }

    @IBAction private func editPasswordTextField(_ sender: UITextField) {
        viewModel.textChanged(sender.text, type: .password)
    }

    private func addTapGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(moveDownKeyboard))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
    }

    @objc private func moveDownKeyboard() {
        view.endEditing(true)
    }

    private func alertAutoLogInRequest() {
        let alert = UIAlertController(title: Style.AutoLogInRequest.title,
                                      message: Style.AutoLogInRequest.message,
                                      preferredStyle: .alert)
        let okay = UIAlertAction(title: Style.AutoLogInRequest.action, style: .default)
        alert.addAction(okay)
        present(alert, animated: true)
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
        findButton.layer.opacity = 0.5
        identityTextField.layer.opacity = 0.5
        passwordTextField.layer.opacity = 0.5
        autoLogInAgreeLabel.layer.opacity = 0.5
        autoLogInCheckButton.layer.opacity = 0.5
        autoLogInTermsButton.layer.opacity = 0.5
    }

    private func deActivateConstraints() {
        logInButtonTopConstraint.isActive = false
        passwordBottomConstraint.isActive = false
        findButtonBottomConstraint.isActive = false
    }

    private func hideAutoLogInAgreeViews() {
        autoLogInAgreeLabel.isHidden = true
        autoLogInCheckButton.isHidden = true
    }

    private func setUpAutoLogInTermsButton() {
        scrollViewContentView.addSubview(autoLogInTermsButton)
        NSLayoutConstraint.activate([
            logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            findButton.bottomAnchor.constraint(equalTo: autoLogInTermsButton.topAnchor),
            autoLogInTermsButton.heightAnchor.constraint(equalToConstant: 50),
            autoLogInTermsButton.leadingAnchor.constraint(equalTo: scrollViewContentView.leadingAnchor),
            autoLogInTermsButton.trailingAnchor.constraint(equalTo: scrollViewContentView.trailingAnchor),
            autoLogInTermsButton.bottomAnchor.constraint(equalTo: scrollViewContentView.bottomAnchor)
        ])
    }
}

extension LogInViewController {
    enum Style {
        enum Navigation {
            static let title = "로그인(꽃피는시절)"
        }
        enum AutoLogInTermsButton {
            static let title = "자동 로그인 연결 약관"
        }
        enum AutoLogInAgreeLabel {
            static let textForAttributed = "자동 로그인 약관"
        }
        enum AutoLogInAgreeButton {
            static let uncheckedNormal = "unchecked_normal"
            static let uncheckedHighlighted = "unchecked_pressed"
            static let checkedNormal = "checked_normal"
            static let checkedHighlighted = "checked_pressed"
        }
        enum AutoLogInRequest {
            static let title = "자동 로그인 약관 동의"
            static let message = "자동 로그인 약관에 동의하시고 로그인하셔야 합니다."
            static let action = "확인"
        }
        enum TextFieldColor {
            static let empty = UIColor.systemBackground.cgColor
            static let valid = UIColor.systemGreen.cgColor
            static let invalid = UIColor.systemRed.cgColor
        }
        enum InformationText {
            static let progress = "로그인 중입니다..."
            static let success = "로그인 성공!"
        }
        enum LogInButtonTitle {
            static let progress = ""
            static let normal = "로그인"
        }
    }
}
