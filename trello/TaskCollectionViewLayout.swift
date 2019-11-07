//
//  TaskCollectionViewLayout.swift
//  trello
//
//  Created by Юрий Нориков on 07.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import UIKit

class TaskCollectionViewLayout: UICollectionViewLayout {

    private let cellPadding: CGFloat = 8
    
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        layoutAttributes.removeAll()
        contentHeight = 0
        
        let columnWidth = contentWidth / CGFloat(collectionView.numberOfSections)
        
        for section in 0..<collectionView.numberOfSections {
            var yOffset: CGFloat = 0
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let columnHeight = columnWidth / 1.1
                
                let frame = CGRect(x: columnWidth * CGFloat(section), y: yOffset, width: columnWidth, height: columnHeight)
                
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                attributes.frame = insetFrame
                layoutAttributes.append(attributes)
                
                contentHeight = max(contentHeight, frame.maxY)
                
                yOffset += columnHeight
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in layoutAttributes {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.item]
    }
}
