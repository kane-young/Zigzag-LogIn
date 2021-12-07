//
//  LogInViewModel.swift
//  Kane-Login
//
//  Created by 이영우 on 2021/12/07.
//

import Foundation

final class LogInViewModel {
    private let validator: Validatable

    private(set) var identity: Observable<TextState> = Observable(value: .empty)
    private(set) var password: Observable<TextState> = Observable(value: .empty)
    private(set) var validatedAll: Observable<Bool> = .init(value: false)

    init(validator: Validatable) {
        self.validator = validator
    }

    func textChanged(_ text: String?, type: ValidationType) {
        switch type {
        case .identity:
            identity.value = validator.validate(text, type: type)
        case .password:
            password.value = validator.validate(text, type: type)
        }
        validatedAll.value = validator.validatedAll()
    }
}
