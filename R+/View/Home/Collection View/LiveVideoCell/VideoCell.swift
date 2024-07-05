//
//  LiveVideoCell.swift
//  R+
//
//  Created by William Johanssen Hutama on 04/07/24.
//

import UIKit
import Kingfisher

// MARK: - Protocol
protocol VideoCellAPI {
    var thumbnailUrl: URL? { get }
    var title: String { get }
}

// MARK: - Collection View Cell
class VideoCell: UICollectionViewCell {
    // View Variable
    private lazy var thumbnailImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .white
        label.contentMode = .top
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [thumbnailImageView, titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8.0
        return stackView
    }()
    
    // Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetContent()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCornerRadius()
    }
}

// MARK: - Init Function
extension VideoCell {
    private func setupView() {
        addView()
        setupConstraints()
    }
    
    private func addView() {
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 20.0)
        ])
    }
}

// MARK: - Prepare For Reuse Function
extension VideoCell {
    private func resetContent() {
        thumbnailImageView.image = nil
        titleLabel.text = nil
    }
}

// MARK: - Layout Subviews Function
extension VideoCell {
    private func setupCornerRadius() {
        thumbnailImageView.layer.masksToBounds = true
        thumbnailImageView.layer.cornerRadius = 5.0
    }
}

// MARK: - Cell Setup
extension VideoCell {
    func setupCell(with api: VideoCellAPI) -> VideoCell {
        thumbnailImageView.kf.setImage(with: api.thumbnailUrl)
        titleLabel.text = api.title
        return self
    }
}
