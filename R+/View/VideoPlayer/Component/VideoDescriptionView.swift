//
//  VideoDescriptionView.swift
//  R+
//
//  Created by William Johanssen Hutama on 05/07/24.
//

import UIKit

// MARK: - Protocol
protocol VideDescriptionAPI {
    var viewCount: Int { get }
    var description: String { get }
}

// MARK: - Component View
class VideoDescriptionView: UIView {
    // View Variable
    private lazy var viewCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var viewDescriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [viewCountLabel, viewDescriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4.0
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCornerRadius()
    }
}

// MARK: - View Setup
extension VideoDescriptionView {
    private func setupView() {
        setupBackgroundColor()
        addView()
        setupConstraint()
    }
    
    private func setupBackgroundColor() {
        backgroundColor = UIColor(white: 0.2, alpha: 1.0)
    }
    
    private func addView() {
        addSubview(stackView)
    }
    
    private func setupConstraint() {
        setupStackViewConstraint()
    }
    
    private func setupStackViewConstraint() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0)
        ])
    }
}

// MARK: - Component Setup
extension VideoDescriptionView {
    func setupComponent(with api: VideDescriptionAPI) {
        viewDescriptionLabel.text = api.description
        viewCountLabel.text = api.viewCount.convertToCountString() + " Views"
    }
}

// MARK: - Layout Subviews Function
extension VideoDescriptionView {
    private func setupCornerRadius() {
        layer.masksToBounds = true
        layer.cornerRadius = 10.0
    }
}
