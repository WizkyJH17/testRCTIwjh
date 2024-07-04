//
//  VideoManager.swift
//  R+
//
//  Created by William Johanssen Hutama on 04/07/24.
//

import Foundation

// MARK: - Enum
enum VideoManagerError: Error {
    case missingData
    case jsonConversionFailed
}

// MARK: - Manager
class VideoManager {
    // Variable
    private let sessionManager: SessionManager = SessionManager()
    private let url: URL? = URL(string:  "https://gist.githubusercontent.com/poudyalanil/ca84582cbeb4fc123a13290a586da925/raw/14a27bd0bcd0cd323b35ad79cf3b493dddf6216b/videos.json")
}

// MARK: - Function
extension VideoManager {
    func fetchVideoList(completion: @escaping(Result<[Video], Error>) -> Void) {
        guard let url else { return }
        sessionManager.request(with: url, completion: { (result) in
            switch result {
            case .success(let data):
                guard let data else {
                    return completion(.failure(VideoManagerError.missingData))
                }
                do {
                    let jsonList = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] ?? []
                    var videos: [Video] = []
                    jsonList.forEach({
                        videos.append(Video(json: $0))
                    })
                    DispatchQueue.main.async {
                        return completion(.success(videos))
                    }
                } catch {
                    return completion(.failure(VideoManagerError.jsonConversionFailed))
                }
            case .failure(let error):
                return completion(.failure(error))
            }
        })
    }
}
