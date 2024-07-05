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
        view.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var authorView: AuthorDetailView = {
        let view: AuthorDetailView = AuthorDetailView()
        return view
    }()
    
    private lazy var videoDetailStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [titleLabel, authorView])
        stackView.axis = .vertical
        stackView.spacing = 8.0
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [videoView, videoDetailStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        setupTabBar()
    }
}

// MARK: - View Setup
extension VideoPlayerViewController {
    private func setupView() {
        setupBackgroundColor()
        addView()
        setupConstraints()
        setupVideoTapGesture()
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
        setupVideoDetailStackViewConstraint()
    }
    
    private func setupStackViewConstraint() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0)
        ])
    }
    
    private func setupVideoViewConstraint() {
        NSLayoutConstraint.activate([
            videoView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0),
            videoView.heightAnchor.constraint(equalTo: videoView.widthAnchor, multiplier: 9/16)
        ])
    }
    
    private func setupVideoDetailStackViewConstraint() {
        NSLayoutConstraint.activate([
            videoDetailStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16.0),
            videoDetailStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16.0)
        ])
    }
    
    private func setupVideoTapGesture() {
        // Single Tap
        let singleTap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(toggleVideoControl))
        singleTap.numberOfTapsRequired = 1
        videoView.addGestureRecognizer(singleTap)
        
        // Double Tap
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goFullScreen))
        doubleTap.numberOfTapsRequired = 2
        videoView.addGestureRecognizer(doubleTap)
        
        // Delays
        singleTap.require(toFail: doubleTap)
        singleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true
    }
    
    @objc private func toggleVideoControl() {
        viewModel.toggleVideoControl()
    }
    
    @objc private func goFullScreen() {
        // TODO: Add Fullscreen
    }
}

// MARK: - Binding Function
extension VideoPlayerViewController {
    private func setupBinding() {
        setupVideoBinding()
        setupTitleBinding()
        setupAuthorDetailBinding()
    }
    
    private func setupVideoBinding() {
        viewModel.videoUrl
            .bind(onNext: { [weak self] (videoUrl) in
                guard let self, let videoUrl else { return }
                videoView.configure(with: videoUrl)
            })
            .disposed(by: disposeBag)
        
        viewModel.videoControl
            .bind(onNext: { [weak self] (control) in
                guard let self else { return }
                switch control {
                case .play:
                    self.videoView.play()
                case .pause:
                    self.videoView.pause()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTitleBinding() {
        viewModel.videoTitle
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupAuthorDetailBinding() {
        viewModel.authorDetail
            .bind(onNext: { [weak self] (api) in
                guard let self, let api else { return }
                self.authorView.setupComponent(with: api)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Will Appear FUnction
extension VideoPlayerViewController {
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupTabBar() {
        hideTabBar()
    }
}
