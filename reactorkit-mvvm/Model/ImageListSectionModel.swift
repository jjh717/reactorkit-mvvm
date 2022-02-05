//
//  DataSourceImageListModel.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//


import RxDataSources

//MARK: - Datasource
struct ImageListSectionModel: AnimatableSectionModelType {
    var index: Int
    var items: [ImageListCellModel]
    
    typealias Identity = Int
    typealias Item = ImageListCellModel
    
    var identity: Int {
        return index
    }
}

extension ImageListSectionModel {
    init(original: ImageListSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

enum ImageListCellModel: IdentifiableType, Equatable {
    static func == (lhs: ImageListCellModel, rhs: ImageListCellModel) -> Bool {
        if lhs.identity == rhs.identity {
            return true
        }
        return false
    }
    
    typealias Identity = String
    
    var identity : Identity {
        switch self {
        case .randomImageList:
            return "randomImageList"
        }
    }
    
    case randomImageList(ImageInfo)
}


