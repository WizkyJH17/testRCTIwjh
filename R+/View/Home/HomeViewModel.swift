//
//  HomeViewModel.swift
//  R+
//
//  Created by William Johanssen Hutama on 04/07/24.
//

import Foundation
import RxRelay

// MARK: - HomeViewModel
class HomeViewModel {
    // Rx Variable
    let liveVideos: BehaviorRelay<[VideoCellAPI]> = BehaviorRelay(value: [])
    let videos: BehaviorRelay<[VideoCellAPI]> = BehaviorRelay(value: [])
    
    // Lifecycle
    init() {
        fetchVideos()
    }
}

// MARK: - API Call
extension HomeViewModel {
    private func fetchVideos() {
        let manager: VideoManager = VideoManager()
        manager.fetchVideoList(completion: { [weak self] (result) in
            guard let self else { return }
            switch result {
            case .success(let videos):
                self.liveVideos.accept(videos.filter({ $0.isLive }))
                self.videos.accept(videos.filter({ !$0.isLive }))
            case .failure(let error):
                print("<HomeViewModel> Error: \(error.localizedDescription)")
            }
        })
    }
}
