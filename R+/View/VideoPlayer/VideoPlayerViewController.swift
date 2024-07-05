//
//  VideoPlayerViewController.swift
//  R+
//
//  Created by William Johanssen Hutama on 05/07/24.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - View Controller
class VideoPlayerViewController: UIViewController {
    // View Variable
    private lazy var videoView: VideoView = {
        let view: VideoView = VideoView()
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [videoView, collectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10.0
        return stackView
    }()
    
    // Variable
    private var viewModel: VideoPlayerViewModel
    private let disposeBag: DisposeBag

    // Lifecycle
    init(with viewModel: VideoPlayerViewModel) {
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()
    }
}

// MARK: - View Setup
extension VideoPlayerViewController {
    private func setupView() {
        setupBackgroundColor()
        addView()
        setupConstraints()
    }
    
    private func setupBackgroundColor() {
        view.backgroundColor = .black
    }
    
    private func addView() {
        view.addSubview(stackView)
    }
    
    private func setupConstraints() {
        setupStackViewConstraint()
        setupVideoViewConstraint()
    }
    
    private func setupStackViewConstraint() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0)
        ])
    }
    
    private func setupVideoViewConstraint() {
        NSLayoutConstraint.activate([
            videoView.heightAnchor.constraint(equalTo: videoView.widthAnchor, multiplier: 9/16)
        ])
    }
}

// MARK: - Binding Function
extension VideoPlayerViewController {
    private func setupBinding() {
        setupVideoBinding()
    }
    
    private func setupVideoBinding() {
        viewModel.videoUrl
            .bind(onNext: { [weak self] (videoUrl) in
                guard let self, let videoUrl else { return }
                videoView.configure(with: videoUrl)
            })
            .disposed(by: disposeBag)
    }
}
