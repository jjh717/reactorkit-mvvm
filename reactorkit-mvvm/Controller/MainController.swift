//
//  MainController.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//

import UIKit
import RxCocoa
import RxSwift
import ReactorKit
import SnapKit
import RxDataSources
import Kingfisher

final class MainController: BaseViewController, ReactorKit.View {
    private lazy var imageListTableView = UITableView().then {
        $0.bounces = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.allowsSelectionDuringEditing = false
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.register(ImageListCell.self, forCellReuseIdentifier: String(describing: ImageListCell.self))
    }
 
    private let dataSource = RxTableViewSectionedReloadDataSource<ImageListSectionModel>(
        configureCell: { (dataSource, tableView, indexPath, section) in
            print("MainController indexPath = ", indexPath)
            switch section {
            case .randomImageList(let model):
                let cell: ImageListCell = tableView.dequeueReusableCell(for: indexPath)
                cell.setData(model: model)
                return cell
            }
        }
    )
    
    deinit {
        print(#function)
    }
    
    public init(reactor: MainReactor) {
        super.init()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
          
        addSubViews()
        setupConstraints()
    }

    private func addSubViews() {
        view.addSubview(imageListTableView)
    }
    
    private func setupConstraints() {
        imageListTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: MainReactor) {
        //image Load - page: 1
        rx.viewDidLoad
            .bind { [weak self] _ in
                self?.reactor?.action.onNext(.fetchRandomImageList)
            }.disposed(by: disposeBag)
               
        //에러, 상태 체크
        reactor.state.map { $0.error }
            .filterNil()
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] in
                self?.showError($0)
            })
            .disposed(by: self.disposeBag)
         
        imageListTableView.rx.willDisplayCell
            .bind(onNext: { [weak self] cell, indexPath in
                self?.reactor?.action.onNext(.checkLoadMoreData(indexPath.row))
            })
            .disposed(by: disposeBag)
         
        reactor.state.map { $0.imageInfoList }
            .distinctUntilChanged()
            .filterNil()
            .map { (result) -> [ImageListSectionModel] in
                print("MainController result = ", result.count)
                let imageList = result.map { ImageListCellModel.randomImageList($0) }
                return [ImageListSectionModel(index: 0, items: imageList)]
            }
            .bind(to: imageListTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
         
        Observable.zip(imageListTableView.rx.itemSelected, imageListTableView.rx.modelSelected(ImageListCellModel.self))
            .bind {[weak self] indexPath, item in
                
                ImageDetailController().do {                    
                    $0.reactor = ImageDetailReactor(provider: reactor.provider, currentIndex: indexPath.row)
                    $0.returnHandler = { [weak self] index in
                        self?.reactor?.action.onNext(.checkLoadMoreData(index))
                        self?.imageListTableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: false)
                    }
                    $0.modalPresentationStyle = .fullScreen
                    self?.present($0, animated: false, completion: {})
                }
                
            }.disposed(by: disposeBag)
    }
}
 
