//
//  Video.swift
//  R+
//
//  Created by William Johanssen Hutama on 04/07/24.
//

import Foundation

// Typealias
typealias VideoDetailAPI = VideoPlayerAPI & AuthorDetailAPI & VideDescriptionAPI

// MARK: - Model
class Video: VideoCellAPI, VideoDetailAPI, FavoriteVideoAPI {
    // Variable
    var id: String
    var title: String
    var thumbnailUrl: URL?
    var duration: TimeInterval
    var uploadTime: Date
    var viewCount: Int
    var author: String
    var videoUrl: URL?
    var description: String
    var subscriberCount: Int
    var isLive: Bool
    
    // Lifecycle
    init(json: [String:Any]) {
        id = json["id"] as? String ?? ""
        title = json["title"] as? String ?? "Missing Title"
        thumbnailUrl = (json["thumbnailUrl"] as? String)?.convertToURL()
        duration = (json["duration"] as? String)?.convertToTimeInterval() ?? TimeInterval(0)
        uploadTime = (json["uploadTime"] as? String)?.convertToDate() ?? Date()
        viewCount = (json["views"] as? String)?.convertToViewCount() ?? 0
        author = json["author"] as? String ?? "Missing Author"
        videoUrl = (json["videoUrl"] as? String)?.convertToURL()
        description = json["description"] as? String ?? "Missing Description"
        subscriberCount = (json["subscriber"] as? String)?.convertToSubscriberCount() ?? 0
        isLive = json["isLive"] as? Bool ?? false
    }
    
    init(favouriteVideo: FavoriteVideo) {
        id = favouriteVideo.id
        title = favouriteVideo.title
        thumbnailUrl = favouriteVideo.thumbnailUrl
        duration = favouriteVideo.duration
        uploadTime = favouriteVideo.uploadTime
        viewCount = Int(favouriteVideo.viewCount)
        author = favouriteVideo.author
        videoUrl = favouriteVideo.videoUrl
        description = favouriteVideo.videoDescription
        subscriberCount = Int(favouriteVideo.subscriberCount)
        isLive = false
    }
}

// MARK: - String Extension
private extension String {
    func convertToURL() -> URL? {
        let string = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let atsString = string.replacingOccurrences(of: "http:", with: "https:")
        return URL(string: atsString)
    }
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        return dateFormatter.date(from: self)
    }
    
    func convertToViewCount() -> Int? {
        let cleanedString = self.replacingOccurrences(of: ",", with: "")
        return Int(cleanedString)
    }
    
    func convertToSubscriberCount() -> Int? {
        let cleanedString = self.replacingOccurrences(of: " Subscribers", with: "")
        return Int(cleanedString)
    }
    
    func convertToTimeInterval() -> TimeInterval? {
        let components = self.split(separator: ":")
        guard
            components.count == 2,
            let minutes = Int(components[0]),
            let seconds = Int(components[1])
        else { return nil }
        return TimeInterval(minutes * 60 + seconds)
    }
}
