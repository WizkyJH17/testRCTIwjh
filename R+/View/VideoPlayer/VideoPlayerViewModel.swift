//
//  VideoPlayerViewModel.swift
//  R+
//
//  Created by William Johanssen Hutama on 05/07/24.
//

import RxRelay

// MARK: - Protocol
protocol VideoPlayerAPI {
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
    
    // Lifecycle
    init(with api: VideoDetailAPI) {
        setVideoUrl(api.videoUrl)
        setTitle(api.title)
        setAuthorDetail(api)
        setDescriptionDetail(api)
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
}

// MARK: - Video Control Function
extension VideoPlayerViewModel {
    func toggleVideoControl() {
        let control: VideoControlEnum = videoControl.value == .play ? .pause : .play
        videoControl.accept(control)
    }
}
