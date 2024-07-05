//
//  ViewController.swift
//  R+
//
//  Created by William Johanssen Hutama on 04/07/24.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - View Controller
class HomeViewController: UIViewController {
    // View Variable
    static private var liveVideoSection: NSCollectionLayoutSection = {
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)))
        item.contentInsets.trailing = 16.0
        item.contentInsets.bottom = 10.0
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(0.2)),
            subitems: [item])
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = 16.0
        section.contentInsets.trailing = 16.0
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(40.0)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }()
    
    static private var videoSection: NSCollectionLayoutSection = {
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
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(40.0)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }()
    
    private var collectionViewLayout: UICollectionViewCompositionalLayout = {
        return UICollectionViewCompositionalLayout { (section, environment) in
            switch section {
            case 0:
                return liveVideoSection
            default:
                return videoSection
            }
        }
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "LiveVideoCell")
        collectionView.register(TitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TitleHeaderView")
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    // Variable
    private let headerTitle: [String] = ["Tonton Live sekarang!", "Video Pilihan"]
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var viewModel: HomeViewModel = HomeViewModel()

    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        setupTabBar()
    }
}

// MARK: - View Setup
extension HomeViewController {
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
        Observable
            .combineLatest([viewModel.videos, viewModel.liveVideos])
            .bind(onNext: { [weak self] _ in
                guard let self else { return }
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Will Appear FUnction
extension HomeViewController {
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupTabBar() {
        showTabBar()
    }
}

// MARK: - Collection View Function
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.liveVideos.value.count
        case 1:
            return viewModel.videos.value.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveVideoCell", for: indexPath) as! VideoCell
        switch indexPath.section {
        case 0:
            return cell.setupCell(with: viewModel.liveVideos.value[indexPath.row])
        case 1:
            return cell.setupCell(with: viewModel.videos.value[indexPath.row])
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TitleHeaderView", for: indexPath) as! TitleHeaderView
            return headerView.setup(title: headerTitle[indexPath.section])
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let api = viewModel.videoPlayerAPI(at: indexPath) else { return }
        let viewModel = VideoPlayerViewModel(with: api)
        let viewController = VideoPlayerViewController(with: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
