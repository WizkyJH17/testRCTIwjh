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
    let videos: BehaviorRelay<[Video]> = BehaviorRelay(value: [])
    
    // Lifecycle
    init() {
        fetchVideos()
    }
}

// MARK: - API Call
extension FavoriteViewModel {
    func fetchVideos() {
        let manager: CoreDataManager = CoreDataManager()
        guard let favoriteVideos = manager.fetchAllVideo() else { return }
        videos.accept(favoriteVideos.map({ Video(favouriteVideo: $0) }))
    }
}

// MARK: - Function
extension FavoriteViewModel {
    func videoPlayerAPI(at index: Int) -> VideoDetailAPI? {
        return videos.value[index]
    }
}
