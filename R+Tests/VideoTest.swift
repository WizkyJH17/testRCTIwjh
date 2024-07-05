//
//  HomeTest.swift
//  R+Tests
//
//  Created by William Johanssen Hutama on 05/07/24.
//

import XCTest

final class VideoTest: XCTestCase {
    var video: Video!
    
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
    }

    override func tearDownWithError() throws {
        video = nil
    }
    
    func testVideoVariable() {
        XCTAssertEqual(video.id, "test")
        XCTAssertEqual(video.title, "testinG Title")
        XCTAssertEqual(video.thumbnailUrl, URL(string: "https://thumbnailTesting/url.png"))
        XCTAssertEqual(video.videoUrl, URL(string: "https://videoUrl.com/test.mp4"))
        XCTAssertEqual(video.duration, 61)
        XCTAssertEqual(video.viewCount, 24969123)
        XCTAssertEqual(video.author, "Test author 6")
        XCTAssertEqual(video.description, "testing Description")
        XCTAssertEqual(video.subscriberCount, 25254545)
        XCTAssertEqual(video.isLive, true)
    }

    func testVideoProtocol() {
        XCTAssertTrue((video as Any) is VideoCellAPI)
        XCTAssertTrue((video as Any) is VideoDetailAPI)
    }
}
