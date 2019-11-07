//
//  TaskCollectionViewCell.swift
//  trello
//
//  Created by Юрий Нориков on 07.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import UIKit

class TaskCollectionViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.random()

        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        titleLabel.frame = CGRect(x: 4, y: 2, width: frame.width - 8, height: 20)
        descriptionLabel.frame = CGRect(x: 4, y: 26, width: frame.width - 8, height: 0)
        
        /// line separator
        let lineView = UIView(frame: CGRect(x: 2, y: 24, width: frame.width - 4, height: 1))
        lineView.backgroundColor = .black
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(titleLabel)
    }
    
    func setupCell(with task: Task) {
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        descriptionLabel.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
