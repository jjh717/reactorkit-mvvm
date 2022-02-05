//
//  SearchReactor.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//
 
import ReactorKit
import RxSwift
import RxOptional
 
class SearchReactor: Reactor {
    let initialState: State
    
    let provider: ServiceProviderType
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        
        initialState = State()
    }
    
    enum Action {
        case searchImage(String)
        case checkLoadMoreData(Int)
    }
    
    enum Mutation {
        case setImageInfoList(SearchResult)
        case setIsDataLoading(Bool)
        case setPageNumber(Int)
        case setSearchKeyword(String)
        
        case checkImageDataReset(String)
        
        case setError(Error)
    }
    
    struct State {
        var error: Error?
        var imageInfoList: [ImageInfo]?
        var searchKeyword = "" //검색어
        
        var page = 1
        var per_page = 10 //이미지 N 개씩 호출
        
        var isDataLoading = false
        var isDataEnd = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchImage(let keyword):
            let relate = Observable.concat([
                Observable.just(Mutation.checkImageDataReset(keyword)),
                Observable.just(Mutation.setSearchKeyword(keyword))
            ])
            
            if keyword == "" {
                return relate
            } else {
                return Observable.concat([
                    relate,
                    searchImageList(keyword: keyword)
                ])
            }
            
        case .checkLoadMoreData(let index):
            let currentItemCount = currentState.imageInfoList?.count ?? 0
            if !currentState.isDataLoading,
                !currentState.isDataEnd,
                index > currentItemCount - currentState.per_page / 2 {
                
                return Observable.concat([
                    Observable.just(Mutation.setPageNumber(currentState.page + 1)),
                    searchImageList(keyword: currentState.searchKeyword)
                ])
            }
            
            return Observable.empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        case .setError(let error):
            newState.error = error
            
        case .setSearchKeyword(let keyword):
            newState.searchKeyword = keyword
            
        case .checkImageDataReset(let keyword):
            if currentState.searchKeyword != keyword {
                newState.imageInfoList = []
                newState.page = 1
            }
            
        case .setImageInfoList(let result):
            if result.total_pages == currentState.page || result.total == 0 {
                newState.isDataEnd = true
            }
            
            if newState.imageInfoList == nil {
                newState.imageInfoList = result.results
            } else if let list = result.results {
                newState.imageInfoList?.append(contentsOf: list)
            }
            
            provider.userActionSupport.updateImageListEvent.onNext(.updateImageList(newState.imageInfoList ?? []))

        case .setIsDataLoading(let state):
            newState.isDataLoading = state
            
        case .setPageNumber(let index):
            newState.page = index
        }
                        
        return newState
    }
    
    private func searchImageList(keyword: String) -> Observable<Mutation> {
        guard !(currentState.isDataLoading) else { return Observable.empty() }
        
        let request = provider.unSplashRequest.searchImage(term: keyword, page: currentState.page, per_page: currentState.per_page)
                .map { Mutation.setImageInfoList($0) }
                .catch { return .just(Mutation.setError($0)) }
        
        return  Observable.concat([
            Observable.just(Mutation.setIsDataLoading(true)),
            request,
            Observable.just(Mutation.setIsDataLoading(false))
        ])
    }
}
