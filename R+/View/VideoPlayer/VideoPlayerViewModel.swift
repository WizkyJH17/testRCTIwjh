//
//  VideoPlayerViewModel.swift
//  R+
//
//  Created by William Johanssen Hutama on 05/07/24.
//

import RxRelay

// MARK: - Protocol
protocol VideoPlayerAPI {
    var id: String { get }
    var videoUrl: URL? { get }
    var title: String { get }
}

// MARK: - Enum
enum VideoControlEnum {
    case play
    case pause
}

// MARK: - View Model
class VideoPlayerViewModel {
    // Rx Variable
    let videoControl: BehaviorRelay<VideoControlEnum> = BehaviorRelay(value: .play)
    let videoUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    let videoTitle: BehaviorRelay<String> = BehaviorRelay(value: "")
    let authorDetail: BehaviorRelay<AuthorDetailAPI?> = BehaviorRelay(value: nil)
    let videoDescription: BehaviorRelay<VideDescriptionAPI?> = BehaviorRelay(value: nil)
    let isFavorite: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    // Variable
    private var api: VideoDetailAPI
    private var id: String
    
    // Lifecycle
    init(with api: VideoDetailAPI) {
        self.api = api
        self.id = api.id
        setVideoUrl(api.videoUrl)
        setTitle(api.title)
        setAuthorDetail(api)
        setDescriptionDetail(api)
        checkFavorite()
    }
}

// MARK: - Set Function
extension VideoPlayerViewModel {
    private func setVideoUrl(_ url: URL?) {
        videoUrl.accept(url)
    }
    
    private func setTitle(_ title: String) {
        videoTitle.accept(title)
    }
    
    private func setAuthorDetail(_ api: AuthorDetailAPI) {
        authorDetail.accept(api)
    }
    
    private func setDescriptionDetail(_ api: VideDescriptionAPI) {
        videoDescription.accept(api)
    }
    
    private func checkFavorite() {
        let manager = CoreDataManager()
        guard let favouriteIds = manager.fetchAllId() else { return }
        isFavorite.accept(favouriteIds.contains(id))
    }
}

// MARK: - Video Control Function
extension VideoPlayerViewModel {
    func toggleVideoControl() {
        let control: VideoControlEnum = videoControl.value == .play ? .pause : .play
        videoControl.accept(control)
    }
    
    func toggleFavorite() {
        isFavorite.accept(!isFavorite.value)
        switch isFavorite.value {
        case true:
            favoriteVideo()
        case false:
            unfavoriteVideo()
        }
    }
    
    private func unfavoriteVideo() {
        let manager = CoreDataManager()
        manager.deleteVideo(with: id)
    }
    
    private func favoriteVideo() {
        let manager = CoreDataManager()
        guard let api = api as? FavoriteVideoAPI else { return }
        manager.saveVideo(api)
    }
}
