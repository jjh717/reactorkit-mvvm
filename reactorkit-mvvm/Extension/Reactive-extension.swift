//
//  Reactive-extension.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//

import ReactorKit
import RxSwift
import RxCocoa
import UIKit

public extension Reactive where Base : UIViewController {
    var viewWillAppear: Observable<[Any]> {
        return methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
    }
    var viewWillDisappear: Observable<[Any]> {
        return methodInvoked(#selector(UIViewController.viewWillDisappear(_:)))
    }
    var viewDidLoad: Observable<[Any]> {
        return methodInvoked(#selector(UIViewController.viewDidLoad))
    }
    var viewDidAppear: Observable<[Any]> {
        return methodInvoked(#selector(UIViewController.viewDidAppear(_:)))
    }
    var viewDidDisappear: Observable<[Any]> {
        return methodInvoked(#selector(UIViewController.viewDidDisappear(_:)))
    }
}

public extension Observable {
    /// Returns an `Observable` where the nil values from the original `Observable` are skipped
    func unwrap<T>() -> Observable<T> where Element == T? {
        self.filter { $0 != nil }.map { $0! }
    }
}
 
