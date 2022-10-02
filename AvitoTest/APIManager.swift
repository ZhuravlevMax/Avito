//
//  URLSessionProvider.swift
//  AvitoTest
//
//  Created by Максим Журавлев on 29.09.22.
//

import Foundation

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
    
    func downloadContent(fromUrlString: String, completionHandler: @escaping DownloadCompletionHandler) {
        
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
    
    //MARK: - Method for getting data
    //    func getCompany(completion: @escaping DownloadCompletionHandler) {
    //
    //        let BaseURL : String = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
    //
    //        guard let url = URL(string: BaseURL) else {return}
    //
    //        var urlRequest = URLRequest(url: url)
    //
    //        urlRequest.httpMethod = "GET"
    //
    //        urlRequest.setValue("application/json", forHTTPHeaderField: "content-Type")
    //
    //        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
    //
    //            if let data = data {
    //                do {
    //                    let company = try JSONDecoder().decode(Companies.self, from: data)
    //                    completion(.success(company))
    //                } catch {
    //                    print("StructError")
    //                }
    //            }
    //
    //            if let error = error as? URLError {
    //                completion(.failure(error))
    //            }
    //        }
    //        dataTask.resume()
    //
    //    }
    
}



