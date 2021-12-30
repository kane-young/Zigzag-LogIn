//
//  LogInViewModelTests.swift
//  Kane-LoginTests
//
//  Created by 이영우 on 2021/12/09.
//

import XCTest
@testable import Kane_Login

final class LogInViewModelTests: XCTestCase {
    private var logInViewModel: LogInViewModel!
    private var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        logInViewModel = LogInViewModel(validator: LogInValidator())
        expectation = XCTestExpectation(description: "react success")
    }

    override func tearDownWithError() throws {
        logInViewModel = nil
        expectation = nil
    }

    func test_password_bind() {
        let tooShortPassword = "PW"
        logInViewModel.password.bind { state in
            switch state {
            case .invalid:
                self.expectation.fulfill()
            default:
                XCTFail("valid, empty is not suitable")
            }
        }
        logInViewModel.textChanged(tooShortPassword, type: .password)
        wait(for: [expectation], timeout: 2.0)
    }

    func test_identity_bind() {
        let tooLongPassword = "TooLongPassWord"
        logInViewModel.password.bind { state in
            switch state {
            case .invalid:
                self.expectation.fulfill()
            default:
                XCTFail("valid, empty is not suitable")
            }
        }
        logInViewModel.textChanged(tooLongPassword, type: .password)
        wait(for: [expectation], timeout: 2.0)
    }

    func test_validatedAll_bind() {
        let identity = "identity"
        let password = "password"
        logInViewModel.validatedAll.bind { isValidated in
            switch isValidated {
            case true:
                self.expectation.fulfill()
            case false:
                break
            }
        }
        logInViewModel.textChanged(identity, type: .identity)
        logInViewModel.textChanged(password, type: .password)
        wait(for: [expectation], timeout: 2.0)
    }
}
