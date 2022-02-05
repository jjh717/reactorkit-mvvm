//
//  MainReactor.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//
 
import ReactorKit
import RxSwift
import RxOptional
 
class MainReactor: Reactor {
    let initialState: State
    
    let provider: ServiceProviderType
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        
        initialState = State()
    }
     
    enum Action {
        case fetchRandomImageList
        case checkLoadMoreData(Int)
    }
    
    enum Mutation {
        case setImageInfoList([ImageInfo]?)
        case setIsDataLoading(Bool)
        case setPageNumber(Int)
        
        case setError(Error)
    }
    
    struct State {
        var error: Error?
        var imageInfoList: [ImageInfo]?
        
        var page = 1
        var per_page = 10 //이미지 N 개씩 호출
        
        var isDataLoading = false
        var isDataEnd = false
    }
          
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchRandomImageList:
            return fetchRandomImageList()
        case .checkLoadMoreData(let index):
            let currentItemCount = currentState.imageInfoList?.count ?? 0
            if !currentState.isDataLoading,
                !currentState.isDataEnd,
                index > currentItemCount - currentState.per_page / 2 {
                
                return Observable.concat([
                    Observable.just(Mutation.setPageNumber(currentState.page + 1)),
                    fetchRandomImageList()
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
            
        case .setImageInfoList(let data):
            if data?.count != currentState.per_page {
                newState.isDataEnd = true
            }
            
            if newState.imageInfoList == nil {
                newState.imageInfoList = data
            } else if let list = data {
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
    
    private func fetchRandomImageList() -> Observable<Mutation> {
        guard !(currentState.isDataLoading) else { return Observable.empty() }
        
        let request = provider.unSplashRequest.fetchRandomImage(page: currentState.page, per_page: currentState.per_page)
                .map { Mutation.setImageInfoList($0) }
                .catch { return .just(Mutation.setError($0)) }
        
        return  Observable.concat([
            Observable.just(Mutation.setIsDataLoading(true)),
            request,
            Observable.just(Mutation.setIsDataLoading(false))
        ])
    }
}
