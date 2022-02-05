//
//  UIImageVIew-extension.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/04.
//

import UIKit
import Kingfisher

extension UIImageView {    
    func setKfImage(_ imageURL: URL, targetSize: CGSize, contentMode: UIView.ContentMode = .scaleAspectFill, placeholderSize: CGSize = .zero, isNoneErrorLabel: Bool = false, completed: ((_ isSuccess: Bool) -> ())? = nil) {

        let imageCache = KingfisherManager.shared.cache
       
        let processor = DownsamplingImageProcessor(size: targetSize)
        self.kf.setImage(with: imageURL, options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage
        ]) { result in
            switch result {
            case .success(_):
                if let success = completed {
                    success(true)
                }
            case .failure(_):
                imageCache.removeImage(forKey: imageURL.absoluteString)
                
                KingfisherManager.shared.cache.cleanExpiredMemoryCache()
                
                 if let success = completed {
                    success(false)
                }
            }
        }
    }
}
