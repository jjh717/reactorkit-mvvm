//
//  UIScrollView-extension.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/05.
//

import UIKit

extension UIScrollView {
    /// - Parameter edgeOffset: bottom에서 떨어진 정도
    /// - Returns: 스크롤뷰가 bottom에 도달했는지 여부
    func isNearBottomEdge(edgeOffset: CGFloat = 80) -> Bool {
        return contentOffset.y + frame.size.height + edgeOffset > contentSize.height
    }
}
