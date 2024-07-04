//
//  TitleHeaderView.swift
//  R+
//
//  Created by William Johanssen Hutama on 04/07/24.
//

import UIKit

// MARK: - Collection View Header
class TitleHeaderView: UICollectionReusableView {
    // View Variable
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.textColor = .white
        return label
    }()

    // Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
//        print("Deinit: \(classForCoder)")
    }
}

// MARK: - Init Function
extension TitleHeaderView {
    private func setupView() {
        addView()
        setupConstraint()
    }
    
    private func addView() {
        addSubview(label)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - Init Function
extension TitleHeaderView {
    func setup(title: String) -> TitleHeaderView {
        label.text = title
        return self
    }
}
