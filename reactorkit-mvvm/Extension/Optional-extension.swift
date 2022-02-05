//
//  Optional-extension.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//

import Foundation

public extension Optional where Wrapped == String {
    func unwrapped () -> String {
        guard let value: String = self else { return "" }
        return value
    }
}
