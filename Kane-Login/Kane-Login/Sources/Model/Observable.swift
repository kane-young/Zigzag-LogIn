//
//  Observable.swift
//  Kane-Login
//
//  Created by 이영우 on 2021/12/07.
//

import Foundation

final class Observable<Element> {
    var value: Element {
        didSet {
            handler?(value)
        }
    }

    private var handler: ((Element) -> Void)?

    init(value: Element) {
        self.value = value
    }

    func bind(_ handler: @escaping (Element) -> Void) {
        self.handler = handler
    }
}
