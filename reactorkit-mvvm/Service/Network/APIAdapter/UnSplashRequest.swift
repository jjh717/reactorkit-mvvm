//
//  UnSplashAPIService.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//
 
import RxSwift

protocol UnSplashRequestType {    
    func fetchRandomImage(page: Int, per_page: Int) -> Observable<[ImageInfo]>
    func searchImage(term: String, page: Int, per_page: Int) -> Observable<SearchResult>
}
 
class UnSplashRequest: APIService, UnSplashRequestType {
    func fetchRandomImage(page: Int, per_page: Int) -> Observable<[ImageInfo]> {
        return fetch(request: UserEndpoint.getRandomImageList(page: page, per_page: per_page))
    }
    
    func searchImage(term: String, page: Int, per_page: Int) -> Observable<SearchResult> {
        return fetch(request: UserEndpoint.searchTerm(query: term, page: page, per_page: per_page))
    }
}
