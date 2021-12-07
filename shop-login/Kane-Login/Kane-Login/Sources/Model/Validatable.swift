//
//  Validatable.swift
//  Kane-Login
//
//  Created by 이영우 on 2021/12/07.
//

import Foundation

protocol Validatable {
    func validate(_ text: String?, type: ValidationType) -> Bool
    func validatedAll() -> Bool
}
