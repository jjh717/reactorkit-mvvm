//
//  ImageDetailController.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources

final class ImageDetailController: BaseViewController, ReactorKit.View {
    public var returnHandler: ((Int) -> (Void))?
    
    private lazy var nameLabel = UILabel().then {
        $0.text = ""
    }
    
    private lazy var backButton = UIButton().then {
        $0.setTitle("< Back", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    private lazy var imageDetailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.isScrollEnabled = true
        
        if let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        $0.register(ImageDetailCell.self, forCellWithReuseIdentifier: String(describing: ImageDetailCell.self))
    }
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<ImageDetailViewSectionModel>(
        configureCell: { (dataSource, collectionView, indexPath, section) in
            print("ImageDetailController indexPath = ", indexPath)
            switch section {
            case .detailImageList(let model):
                let cell: ImageDetailCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setData(model: model)
                return cell
            }
        }
    ) 

    override func viewDidLoad() {
        addSubViews()
        setupConstraints()
        makeUI()
    }

    private func addSubViews() {
        view.addSubview(imageDetailCollectionView)
        view.addSubview(nameLabel)
        view.addSubview(backButton)
    }
    
    private func setupConstraints() {
        imageDetailCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
    }
    
    deinit {
        print(#function)
    }
    
    func bind(reactor: ImageDetailReactor) {
        backButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: {})
            }).disposed(by: disposeBag)
          
        imageDetailCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        reactor.state.map { $0.imageInfoList }
            .filterNil()
            .map { (result) -> [ImageDetailViewSectionModel] in
                print("ImageDetailController result = ", result.count)
                let imageList = result.map { ImageDetailCellModel.detailImageList($0) }
                return [ImageDetailViewSectionModel(index: 0, items: imageList)]
            }
            .bind(to: imageDetailCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func makeUI() {
        imageDetailCollectionView.performBatchUpdates { [weak self] in
            if let reactor = self?.reactor {
                self?.imageDetailCollectionView.scrollToItem(at: IndexPath(row: reactor.currentState.currentIndex , section: 0), at: .centeredHorizontally, animated: false)
            }

        }
    }
}
  
extension ImageDetailController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()

        visibleRect.origin = imageDetailCollectionView.contentOffset
        visibleRect.size = imageDetailCollectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = imageDetailCollectionView.indexPathForItem(at: visiblePoint) else { return }
 
        returnHandler?(indexPath.row)
    }
}
 
extension ImageDetailController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return imageDetailCollectionView.frame.size
    }
}
