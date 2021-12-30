//
//  LogInValidatorTests.swift
//  Kane-LoginTests
//
//  Created by 이영우 on 2021/12/09.
//

import XCTest
@testable import Kane_Login

final class LogInValidatorTests: XCTestCase {
    var validator: LogInValidator!

    override func setUpWithError() throws {
        validator = LogInValidator()
    }

    override func tearDownWithError() throws {
        validator = nil
    }

    func test_validate_TooShortIdentity() {
        let tooShortIdentity = "id"
        let expectedTextState = TextState.invalid
        let textState = validator.validate(tooShortIdentity, type: .identity)
        XCTAssertEqual(textState, expectedTextState)
    }

    func test_validate_TooLongIdentity() {
        let tooLongIdentity = "veryLongIdentity"
        let expectedTextState = TextState.invalid
        let textState = validator.validate(tooLongIdentity, type: .identity)
        XCTAssertEqual(textState, expectedTextState)
    }

    func test_validate_TooShortPassword() {
        let tooShortPassword = "pw"
        let expectedTextState = TextState.invalid
        let textState = validator.validate(tooShortPassword, type: .password)
        XCTAssertEqual(textState, expectedTextState)
    }

    func test_validate_TooLongPassword() {
        let tooLongPassword = "veryLongPassword"
        let expectedTextState = TextState.invalid
        let textState = validator.validate(tooLongPassword, type: .password)
        XCTAssertEqual(textState, expectedTextState)
    }

    func test_validate_normalIdentity() {
        let identity = "kaneYoung"
        let expectedTextState = TextState.valid
        let textState = validator.validate(identity, type: .identity)
        XCTAssertEqual(textState, expectedTextState)
    }

    func test_validate_normalPassword() {
        let password = "kanePW"
        let expectedTextState = TextState.valid
        let textState = validator.validate(password, type: .password)
        XCTAssertEqual(textState, expectedTextState)
    }

    func test_validate_identityAndPassword_success() {
        let identity = "kaneYoung"
        let password = "kanePW"
        let expectedTextState = true
        validator.validate(identity, type: .identity)
        validator.validate(password, type: .password)
        let isValidated = validator.validatedAll()
        XCTAssertEqual(isValidated, expectedTextState)
    }

    func test_validate_identityAndPassword_failure() {
        let identity = "kaneYoung"
        let password = "TooLongPassword"
        let expectedTextState = false
        validator.validate(identity, type: .identity)
        validator.validate(password, type: .password)
        let isValidated = validator.validatedAll()
        XCTAssertEqual(isValidated, expectedTextState)
    }
}
