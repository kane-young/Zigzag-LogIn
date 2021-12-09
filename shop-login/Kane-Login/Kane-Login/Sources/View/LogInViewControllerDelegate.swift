//
//  LogInViewControllerDelegate.swift
//  Kane-Login
//
//  Created by 이영우 on 2021/12/09.
//

import Foundation

protocol LogInViewControllerDelegate: AnyObject {
    func didSuccessLogIn(identity: String)
}
