//
//  URLSessionProvider.swift
//  AvitoTest
//
//  Created by Максим Журавлев on 29.09.22.
//

import Foundation

enum userDefaultsKeys {
    case nextUpdate
}

class APIManager {
    
    static let shared = APIManager()
    private let allowedDiskSize = 100 * 1024 * 1024
    private lazy var cache: URLCache = {
        return URLCache(memoryCapacity: 0, diskCapacity: allowedDiskSize, diskPath: "gifCache")
    }()

    typealias DownloadCompletionHandler = (Result<Companies, URLError>) -> Void
    
    private func createAndRetrieveURLSession() -> URLSession {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        sessionConfiguration.urlCache = cache
        return URLSession(configuration: sessionConfiguration)
    }
    
    //MARK: - Method for getting data
    func downloadContent(fromUrlString: String, completionHandler: @escaping DownloadCompletionHandler) {
        
        let currentTime = Int(Date().timeIntervalSince1970)
        let nextUpdateTime = UserDefaults.standard.integer(forKey: "\(userDefaultsKeys.nextUpdate)")
        
        if nextUpdateTime == 0 {
            UserDefaults.standard.setValue(currentTime + 3600, forKey: "\(userDefaultsKeys.nextUpdate)")
        }

        if currentTime > nextUpdateTime {
            self.cache.removeAllCachedResponses()
        }

        if currentTime > nextUpdateTime {
            UserDefaults.standard.setValue(currentTime + 3600, forKey: "\(userDefaultsKeys.nextUpdate)")
        }

        guard let downloadUrl = URL(string: fromUrlString) else { return }
        let urlRequest = URLRequest(url: downloadUrl)
        // First try to fetching cached data if exist
        if let cachedData = self.cache.cachedResponse(for: urlRequest) {
            print("Cached data in bytes:", cachedData.data)
            do {
                let company = try JSONDecoder().decode(Companies.self, from: cachedData.data)
                completionHandler(.success(company))
            } catch {
                print("StructError")
            }
            
        } else {
            // No cached data, download content than cache the data
            createAndRetrieveURLSession().dataTask(with: urlRequest) { (data, response, error) in
                
                if let error = error as? URLError {
                    completionHandler(.failure(error))
                } else {
                    guard let response = response, let data = data else {return}
                    let cachedData = CachedURLResponse(response: response, data: data)
                    self.cache.storeCachedResponse(cachedData, for: urlRequest)
                    do {
                        let company = try JSONDecoder().decode(Companies.self, from: cachedData.data)
                        completionHandler(.success(company))
                    } catch {
                        print("StructError")
                    }
                }
            }.resume()
        }
    }
    
}



