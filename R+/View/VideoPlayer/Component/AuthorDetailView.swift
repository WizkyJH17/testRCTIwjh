//
//  AuthorDetailView.swift
//  R+
//
//  Created by William Johanssen Hutama on 05/07/24.
//

import UIKit

// MARK: - Protocol
protocol AuthorDetailAPI {
    var author: String { get }
    var subscriberCount: Int { get }
}

// MARK: - Component View
class AuthorDetailView: UIView {
    // View Variable
    private lazy var authorImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: UIImage(systemName: "person.circle"))
        return imageView
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var subscriberCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [authorNameLabel, subscriberCountLabel])
        stackView.axis = .vertical
        stackView.spacing = 2.0
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [authorImageView, textStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
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
}

// MARK: - View Setup
extension AuthorDetailView {
    private func setupView() {
        addView()
        setupConstraint()
    }
    
    private func addView() {
        addSubview(stackView)
    }
    
    private func setupConstraint() {
        setupAuthorImageViewConstraint()
    }
    
    private func setupAuthorImageViewConstraint() {
        NSLayoutConstraint.activate([
            authorImageView.heightAnchor.constraint(equalToConstant: 40.0),
            authorImageView.heightAnchor.constraint(equalTo: authorImageView.widthAnchor, multiplier: 1.0)
        ])
    }
}

// MARK: - Component Setup
extension AuthorDetailView {
    func setupComponent(with api: AuthorDetailAPI) {
        authorNameLabel.text = api.author
        subscriberCountLabel.text = api.subscriberCount.convertToCountString()
    }
}

// MARK: - Int Extension
extension Int {
    func convertToCountString() -> String {
        if self > 1000000 {
            return "\(self/1000000)M Subscriber"
        } else if self > 1000 {
            return "\(self/1000)K Subscriber"
        } else {
            return "\(self) Subscriber"
        }
    }
}
