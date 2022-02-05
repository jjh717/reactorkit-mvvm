//
//  ImageDetailReactor.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//
 
import ReactorKit
import RxSwift
import RxOptional
 
class ImageDetailReactor: Reactor {
    let initialState: State
      
    let provider: ServiceProviderType
         
    init(provider: ServiceProviderType, currentIndex: Int) {
        self.provider = provider
        initialState = State(currentIndex: currentIndex)
    }
    
    deinit {
        print(#function)
    }
        
    enum Action {
    }
    
    enum Mutation {
        case setImageInfoList([ImageInfo]?)
    }
    
    struct State {
        var imageInfoList: [ImageInfo]?
        
        var currentIndex = -1
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.userActionSupport.updateImageListEvent.flatMap { event -> Observable<Mutation> in
            switch event {
            case .updateImageList(let data):
                return .just(.setImageInfoList(data))
            }
        }
        return Observable.merge(mutation, eventMutation)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setImageInfoList(let data):
            newState.imageInfoList = data
        }
                        
        return newState
    }     
}
