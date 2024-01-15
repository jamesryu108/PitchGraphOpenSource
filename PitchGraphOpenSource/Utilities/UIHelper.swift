//
//  UIHelper.swift
//  PitchGraphOpenSource
//
//  Created by James Ryu on 2024-01-15.
//

import UIKit

struct UIHelper {
    static func createColumnFlowLayout(in view: UIView, padding: CGFloat, height: CGFloat, minimumItemSpacing: CGFloat, totalItems: Int) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let availableWidth: CGFloat = width - (padding * 2) - (minimumItemSpacing * (totalItems >= 2 ? CGFloat(totalItems - 1) : 0))
        let itemWidth = availableWidth / CGFloat(totalItems)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: height)
        return flowLayout
    }
}
