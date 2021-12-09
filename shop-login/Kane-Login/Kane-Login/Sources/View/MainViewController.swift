//
//  ViewController.swift
//  Kane-Login
//
//  Created by 이영우 on 2021/12/03.
//

import UIKit

final class MainViewController: UIViewController {

    private var isLogIn: Bool = false

    @IBAction func touchRightBarButtonItem(_ sender: UIBarButtonItem) {
        if isLogIn {
            changeLogInState()
        } else {
            convertToLogInViewController()
        }
    }

    private func convertToLogInViewController() {
        let logInStoryboard = UIStoryboard(name: UIStoryboard.Name.logIn, bundle: nil)
        if let logInViewController = logInStoryboard
            .instantiateViewController(withIdentifier: LogInViewController.identifier) as? LogInViewController {
            logInViewController.delegate = self
            self.navigationController?.pushViewController(logInViewController, animated: true)
        }
    }

    private func changeLogInState() {
        isLogIn = !isLogIn
        let title = isLogIn ? Style.BarButtonItemTitle.logOut : Style.BarButtonItemTitle.logIn
        navigationItem.rightBarButtonItem?.title = title
    }
}

extension MainViewController: LogInViewControllerDelegate {
    func didSuccessLogIn(identity: String) {
        changeLogInState()
    }
}

extension MainViewController {
    enum Style {
        enum BarButtonItemTitle {
            static let logOut = "로그아웃"
            static let logIn = "로그인"
        }
    }
}
