//
//  SessionManager.swift
//  R+
//
//  Created by William Johanssen Hutama on 04/07/24.
//

import Foundation

// MARK: - Enum
enum NetworkError: Error {
    case timeout
    case failedRetry
    case unknown
}

// MARK: - Manager
class SessionManager {
    internal func request(with url: URL, completion: @escaping(Result<Data?, Error>) -> Void) {
        let urlSession: URLSession = URLSession.shared
        let task: URLSessionTask = urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
            print("Response received")
            
            guard let data else {
                if let error = error as NSError? {
                    print("Requesting url failed with error: \(error.localizedDescription)")
                    return completion(.failure(error))
                }
                print("Requesting url failed with unknown reason")
                return completion(.failure(NetworkError.unknown))
            }
            DispatchQueue.main.async {
                print("Request completed")
                completion(.success(data))
            }
        })
        
        print("Begin request for \(url)")
        task.resume()
    }
}
