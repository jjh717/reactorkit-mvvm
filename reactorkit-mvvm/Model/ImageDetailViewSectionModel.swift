//
//  ImageDetailViewSectionModel.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//


import RxDataSources

//MARK: - Datasource
struct ImageDetailViewSectionModel: AnimatableSectionModelType {
    var index: Int
    var items: [ImageDetailCellModel]
    
    typealias Identity = Int
    typealias Item = ImageDetailCellModel
    
    var identity: Int {
        return index
    }
}

extension ImageDetailViewSectionModel {
    init(original: ImageDetailViewSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

enum ImageDetailCellModel: IdentifiableType, Equatable {
    static func == (lhs: ImageDetailCellModel, rhs: ImageDetailCellModel) -> Bool {
        if lhs.identity == rhs.identity {
            return true
        }
        return false
    }
    
    typealias Identity = String
    
    var identity : Identity {
        switch self {
        case .detailImageList:
            return "detailImageList"
        }
    }
    
    case detailImageList(ImageInfo)
}


