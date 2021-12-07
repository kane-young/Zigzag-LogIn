//
//  ViewController.swift
//  Kane-Login
//
//  Created by 이영우 on 2021/12/03.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func touchRightBarButtonItem(_ sender: UIBarButtonItem) {
        let logInStoryboard = UIStoryboard(name: "LogIn", bundle: nil)
        let logInViewController = logInStoryboard.instantiateViewController(withIdentifier: LogInViewController.identifier)
        self.navigationController?.pushViewController(logInViewController, animated: true)
    }
}
