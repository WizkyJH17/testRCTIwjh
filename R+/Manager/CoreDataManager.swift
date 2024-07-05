//
//  CoreDataManager.swift
//  R+
//
//  Created by William Johanssen Hutama on 05/07/24.
//

import UIKit
import CoreData

// MARK: - Protocol
protocol FavoriteVideoAPI {
    var id: String { get }
    var title: String { get }
    var thumbnailUrl: URL? { get }
    var duration: TimeInterval { get }
    var uploadTime: Date { get }
    var viewCount: Int { get }
    var author: String { get }
    var videoUrl: URL? { get }
    var description: String { get }
    var subscriberCount: Int { get }
    var isLive: Bool { get }
}

// MARK: - Manager
class CoreDataManager {
    // Variable
    private let context: NSManagedObjectContext
    private let fetchRequest: NSFetchRequest<FavoriteVideo>
    
    // Lifecycle
    init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        fetchRequest = NSFetchRequest(entityName: "FavoriteVideo")
    }
    
    deinit {
        print("Deinit: CoreDataManager")
    }
}

// MARK: - Fetch Function
extension CoreDataManager {
    func fetchAllVideo() -> [FavoriteVideo]? {
        fetchRequest.predicate = nil
        do {
            let items = try context.fetch(fetchRequest)
            return items
        } catch {
            print("<CoreDataManager> Error: Failed fetching videos, with message: \(error)")
        }
        return nil
    }
    
    func fetchAllId() -> [String]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteVideo")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["id"]
        do {
            if let items = try context.fetch(fetchRequest) as? [[String: Any]] {
                let ids = items.compactMap { $0["id"] as? String }
                return ids
            }
        } catch {
            print("<CoreDataManager> Error: Failed fetching videos, with message: \(error)")
        }
        return nil
    }
    
    func fetchPredicatedVideo(with predicate: NSPredicate) -> [FavoriteVideo]? {
        fetchRequest.predicate = predicate
        do {
            let items = try context.fetch(fetchRequest)
            return items
        } catch {
            print("<CoreDataManager> Error: Failed fetching videos, with message: \(error)")
        }
        return nil
    }
}

// MARK: - Save Function
extension CoreDataManager {
    func saveVideo(_ api: FavoriteVideoAPI) {
        let newItem = FavoriteVideo(context: context)
        newItem.id = api.id
        newItem.title = api.title
        newItem.thumbnailUrl = api.thumbnailUrl
        newItem.duration = api.duration
        newItem.uploadTime = api.uploadTime
        newItem.viewCount = Int64(api.viewCount)
        newItem.author = api.author
        newItem.videoUrl = api.videoUrl
        newItem.videoDescription = api.description
        newItem.subscriberCount = Int64(api.subscriberCount)
        saveContext()
    }
}

// MARK: - Delete Function
extension CoreDataManager {
    func deleteVideo(with id: String) {
        let predicate: NSPredicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let video = fetchPredicatedVideo(with: predicate)?.first else {
            return print("<CoreDataManager> Error: Failed to delete video due to missing video")
        }
        context.delete(video)
        saveContext()
    }
    
    func deleteAllVideos() {
        let deleteFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteVideo")
        let deleteRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetchRequest)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("<CoreDataManager> Error: Failed to delete all videos, with message: \(error)")
        }
    }
}

// MARK: - Private Function
extension CoreDataManager {
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("<CoreDataManager> Error: Failed saving context, with message: \(error)")
        }
    }
}
