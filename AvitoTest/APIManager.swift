//
//  URLSessionProvider.swift
//  AvitoTest
//
//  Created by Максим Журавлев on 29.09.22.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    
    //MARK: - Method for getting data
    func getCompany(completion: @escaping (Result<Companies,URLError>) -> Void) {
        
        let BaseURL : String = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"

        if let url = URL(string: BaseURL) {

            var urlRequest = URLRequest(url: url)

            urlRequest.httpMethod = "GET"
 
            urlRequest.setValue("application/json", forHTTPHeaderField: "content-Type")
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                
                if let response = response {
                    print(response)
                }
                
                if let data = data {
                    do {
                        let company = try JSONDecoder().decode(Companies.self, from: data)
                        completion(.success(company))
                    } catch {
                        print("StructError")
                    }
                }
                
                if let error = error as? URLError {
                    completion(.failure(error))
                }
            }
            dataTask.resume()
        }
    }
    
}



