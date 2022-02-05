//
//  Collection-extension.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//

import Foundation

public extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
