//
//  LogInValidator.swift
//  Kane-Login
//
//  Created by 이영우 on 2021/12/07.
//

import Foundation

final class LogInValidator: Validatable {
    private var isIdentityValidation: Bool = false
    private var isPasswordValidation: Bool = false

    func validate(_ text: String?, type: ValidationType) -> Bool {
        guard let text = text else { return false }
        switch type {
        case .identity:
            return validateIdentity(text)
        case .password:
            return validatePassword(text)
        }
    }

    func validatedAll() -> Bool {
        return isIdentityValidation && isPasswordValidation
    }

    private func validateIdentity(_ identity: String) -> Bool {
        isIdentityValidation = validateLength(identity) && validateWhiteSpace(identity)
        return isIdentityValidation
    }

    private func validatePassword(_ password: String) -> Bool {
        isPasswordValidation = validateLength(password) && validateWhiteSpace(password)
        return isPasswordValidation
    }

    private func validateLength(_ text: String) -> Bool {
        return (6..<12) ~= text.count
    }

    private func validateWhiteSpace(_ text: String) -> Bool {
        return text.contains(" ") == false
    }
}
