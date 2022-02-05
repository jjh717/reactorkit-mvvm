//
//  ImageListCell.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//

import UIKit
import RxSwift
import Kingfisher
import ReactorKit

class ImageListCell: UITableViewCell {
    public lazy var thumbImageView = UIImageView().then {
        $0.backgroundColor = .clear
    }
      
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        contentView.backgroundColor = .clear
        
        addSubViews()
        setupConstraints()
    }

    private func addSubViews() {
        contentView.addSubview(thumbImageView)
    }
    
    private func setupConstraints() {
        thumbImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().priority(100)
            make.height.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public func setData(model: ImageInfo?) {
        guard let model = model else { return }
        
        if let imageURL = URL(string: model.urls?.small ?? "") {
            
            if let width = model.width,
               let height = model.height {
                let imageHeight = CGFloat(height) * UIScreen.main.bounds.size.width / CGFloat(width)
                                
                thumbImageView.snp.updateConstraints { make in
                    make.height.equalTo(imageHeight)
                }
                
                thumbImageView.setKfImage(imageURL, targetSize: CGSize(width: UIScreen.main.bounds.size.width, height: imageHeight))
            }
        }
    }
    
    override func prepareForReuse() {        
        thumbImageView.image = nil
        thumbImageView.kf.cancelDownloadTask()
        disposeBag = DisposeBag()
    }
}

