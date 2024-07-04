//
//  LiveVideoCell.swift
//  R+
//
//  Created by William Johanssen Hutama on 04/07/24.
//

import UIKit

// MARK: - Collection View Cell
class LiveVideoCell: UICollectionViewCell {
    
    // Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
