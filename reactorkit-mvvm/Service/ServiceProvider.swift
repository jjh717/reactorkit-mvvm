//
//  ServiceProvider.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//

import Foundation

protocol ServiceProviderType: AnyObject {
    var unSplashRequest: UnSplashRequestType { get }
    var userActionSupport: UserActionSupport  { get }
}

final class ServiceProvider: ServiceProviderType {
    lazy var unSplashRequest: UnSplashRequestType = UnSplashRequest()
    lazy var userActionSupport = UserActionSupport()
}
