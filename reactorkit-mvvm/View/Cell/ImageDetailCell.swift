//
//  ImageDetailCell.swift
///  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//

import UIKit
import RxSwift
import Kingfisher

class ImageDetailCell: UICollectionViewCell {
    private lazy var detailImageVIew = UIImageView().then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        setupConstraints()
    }
    
    private func addSubViews() {
        contentView.addSubview(detailImageVIew)
    }
    
    private func setupConstraints() {
        detailImageVIew.snp.makeConstraints { make in
            make.edges.equalToSuperview()            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setData(model: ImageInfo?) {
        guard let model = model else { return }
        
        if let imageURL = URL(string: model.urls?.regular ?? "") {
            
            if let width = model.width,
               let height = model.height {
                let imageHeight = CGFloat(height) * UIScreen.main.bounds.size.width / CGFloat(width)
                
                detailImageVIew.setKfImage(imageURL, targetSize: CGSize(width: UIScreen.main.bounds.size.width, height: imageHeight))  
            }
        }
    }
    
    override func prepareForReuse() {
        detailImageVIew.image = nil
        detailImageVIew.kf.cancelDownloadTask()
        disposeBag = DisposeBag()
    }
}

