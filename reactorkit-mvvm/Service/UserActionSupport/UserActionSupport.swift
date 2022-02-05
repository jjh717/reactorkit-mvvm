//
//  UserActionSupport.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//
 
import RxSwift

enum UserEvent {
    case updateImageList([ImageInfo])
}
class UserActionSupport: APIService {
    let updateImageListEvent = BehaviorSubject<UserEvent>(value: .updateImageList([]))
}
