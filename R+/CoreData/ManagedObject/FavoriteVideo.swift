//
//  FavoriteVideo.swift
//  R+
//
//  Created by William Johanssen Hutama on 05/07/24.
//

import Foundation
import CoreData

// MARK: - Core Data Model
@objc(FavoriteVideo)
public class FavoriteVideo: NSManagedObject, VideoCellAPI {
    // Variable
    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var thumbnailUrl: URL?
    @NSManaged public var duration: TimeInterval
    @NSManaged public var uploadTime: Date
    @NSManaged public var viewCount: Int64
    @NSManaged public var author: String
    @NSManaged public var videoUrl: URL?
    @NSManaged public var videoDescription: String
    @NSManaged public var subscriberCount: Int64
}

