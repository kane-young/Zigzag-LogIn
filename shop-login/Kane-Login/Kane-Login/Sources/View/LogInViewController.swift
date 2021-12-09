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
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    private lazy var autoLogInTermsButton: UIButton = {
        let autoLogInTermsButton = UIButton()
        autoLogInTermsButton.setTitle("자동 로그인 연결 약관", for: .normal)
        autoLogInTermsButton.backgroundColor = .systemGray4
        autoLogInTermsButton.setTitleColor(.darkGray, for: .normal)
        autoLogInTermsButton.translatesAutoresizingMaskIntoConstraints = false
        return autoLogInTermsButton
    }()

    private var ispressed = false
    private var viewModel = LogInViewModel(validator: LogInValidator())

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelBind()
        configureLabels()
        configureNavigationBar()
        distinguishAutoLogIn()
        configureTextFields()
        addTapGestureRecognizer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNotification()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotification()
    }

    private func configureNavigationBar() {
        self.navigationItem.title = "로그인(꽃피는시절)"
    }

    private func configureLabels() {
        configureInformationLabels()
        configureAutoLogInAgreeLabel()
    }

    private func configureTextFields() {
        identityTextField.layer.borderWidth = 1
        passwordTextField.layer.borderWidth = 1
        identityTextField.layer.borderColor = UIColor.systemBackground.cgColor
        passwordTextField.layer.borderColor = UIColor.systemBackground.cgColor
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
        if ispressed {
            self.ispressed = false
            sender.setImage(UIImage(named: "unchecked_normal"), for: .normal)
            sender.setImage(UIImage(named: "unchecked_pressed"), for: .highlighted)
        } else {
            self.ispressed = true
            sender.setImage(UIImage(named: "checked_normal"), for: .normal)
            sender.setImage(UIImage(named: "checked_pressed"), for: .highlighted)
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
            subInformationLabel.isHidden = true
            informationLabel.text = "로그인 중입니다..."
            setViewsOpacity()
            setViewsDisabled()
            sender.setTitle("", for: .normal)
            sender.configuration?.showsActivityIndicator = true
            DispatchQueue.global().async {
                sleep(5)
                DispatchQueue.main.async {
                    self.informationLabel.text = "로그인 성공!"
                }
            }
        } else {
            alert()
        }
    }

    @IBAction func editIdentityTextField(_ sender: UITextField) {
        viewModel.textChanged(sender.text, type: .identity)
    }

    @IBAction func editPasswordTextField(_ sender: UITextField) {
        viewModel.textChanged(sender.text, type: .password)
    }

    // MARK: Method associated Notification
    private func setUpNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: Set Keyboard associated Method
    private func addTapGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(moveDownKeyboard))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrameValue = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) else {
            return
        }
        let endFrame = endFrameValue.cgRectValue
        scrollViewBottomConstraint.isActive = false
        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                        constant: -endFrame.height)
        scrollViewBottomConstraint.isActive = true
        scrollView.contentInset.bottom = 30
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollViewBottomConstraint.isActive = false
        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        scrollViewBottomConstraint.isActive = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func moveDownKeyboard() {
        view.endEditing(true)
    }

    private func alert() {
        let alert = UIAlertController(title: "자동 로그인 약관 동의",
                                      message: "자동 로그인 약관에 동의하시고 로그인하셔야 합니다.",
                                      preferredStyle: .alert)
        let okay = UIAlertAction(title: "확인", style: .default)
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

    private func distinguishAutoLogIn() {
        let isAgreed = UserDefaults.standard.bool(forKey: "AutoLogIn")
        if isAgreed == true {
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
