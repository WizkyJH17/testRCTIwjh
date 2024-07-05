//
//  VideoPlayerTest.swift
//  R+Tests
//
//  Created by William Johanssen Hutama on 05/07/24.
//

import XCTest

final class VideoPlayerTest: XCTestCase {
    var video: Video!
    var viewController: VideoPlayerViewController!
    var viewModel: VideoPlayerViewModel!

    override func setUpWithError() throws {
        video = Video(json: [
            "id":"test",
            "title": "testinG Title",
            "thumbnailUrl": "https://thumbnailTesting/url.png",
            "duration": "1:01",
            "uploadTime": "May 9, 2011",
            "views": "24,969,123",
            "author": "Test author 6",
            "videoUrl": "http://videoUrl.com/test.mp4",
            "description": "testing Description",
            "subscriber": "25254545 Subscribers",
            "isLive": true
        ])
        
        viewModel = VideoPlayerViewModel(with: video)
        viewController = VideoPlayerViewController(with: viewModel)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        video = nil
        viewModel = nil
        viewController = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModelInitialRelay() {
        XCTAssertEqual(viewModel.videoControl.value, .play)
        XCTAssertEqual(viewModel.videoUrl.value, URL(string: "https://videoUrl.com/test.mp4"))
        XCTAssertEqual(viewModel.videoTitle.value, "testinG Title")
        XCTAssert((viewModel.authorDetail.value as Any) is AuthorDetailAPI)
        XCTAssert((viewModel.videoDescription.value as Any) is VideoDetailAPI)
        XCTAssertFalse(viewModel.isFavorite.value)
    }

}
