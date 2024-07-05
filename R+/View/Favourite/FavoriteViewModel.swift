//
//  FavoriteViewModel.swift
//  R+
//
//  Created by William Johanssen Hutama on 05/07/24.
//

import Foundation
import RxRelay

// MARK: - HomeViewModel
class FavoriteViewModel {
    // Rx Variable
    let favoriteVideos: BehaviorRelay<[FavoriteVideo]> = BehaviorRelay(value: [])
    let title: BehaviorRelay<String> = BehaviorRelay(value: "lol")
    
    // Lifecycle
    init() {
        fetchVideos()
    }
}

// MARK: - API Call
extension FavoriteViewModel {
    func fetchVideos() {
        let manager: CoreDataManager = CoreDataManager()
        guard let videos = manager.fetchAllVideo() else { return }
        favoriteVideos.accept(videos)
    }
}
