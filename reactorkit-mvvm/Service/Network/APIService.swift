//
//  APIService.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//

import Foundation
import RxSwift
import Alamofire

protocol APIServiceProtocol {
    func fetch<T: Codable>(request: UserEndpoint) -> Observable<T>
}
 
class APIService: APIServiceProtocol {
    func fetch<T: Codable>(request: UserEndpoint) -> Observable<T> {
        return Observable.create { observer -> Disposable in
            AF.request(request).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let model: T = try JSONDecoder().decode(T.self, from: data )
                        observer.onNext(model)
                        
                    } catch let error {
                        observer.onError(error)
                    }
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    } 
}
