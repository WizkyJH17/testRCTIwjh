//
//  FavoriteViewController.swift
//  R+
//
//  Created by William Johanssen Hutama on 04/07/24.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteViewController: UIViewController {
    private var collectionViewLayout: UICollectionViewCompositionalLayout = {
        return UICollectionViewCompositionalLayout { (section, environment) in
            let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
            item.contentInsets.bottom = 16.0
            let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.45)),
                subitems: [item])
            let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
            section.contentInsets.leading = 16.0
            section.contentInsets.trailing = 16.0
            return section
        }
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "VideoCell")
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    // Variable
    private let viewModel: FavoriteViewModel = FavoriteViewModel()
    private let disposeBag: DisposeBag = DisposeBag()
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchVideos()
        setupNavBar()
    }
}

// MARK: - View Setup
extension FavoriteViewController {
    private func setupView() {
        setupBackgroundColor()
        addView()
        setupConstraints()
        setupBinding()
    }
    
    private func setupBackgroundColor() {
        view.backgroundColor = .black
    }
    
    private func addView() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBinding() {
        viewModel.favoriteVideos
            .bind(to: collectionView.rx.items) { [weak self] (collectionView, row, api) -> UICollectionViewCell in
                guard self != nil else { return UICollectionViewCell() }
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: IndexPath(index: row)) as! VideoCell
                return cell.setupCell(with: api)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Will Appear Fnction
extension FavoriteViewController {
    private func setupNavBar() {
        title = "Video Favoritmu"
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
