//
//  URLSessionProvider.swift
//  AvitoTest
//
//  Created by Максим Журавлев on 29.09.22.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    
    //MARK: - метод для запроса текущей погоды
    func getCompany(completion: ((Companies) -> Void)?) {
        
        let BaseURL : String = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
        //url по которому будем получать данные
        if let url = URL(string: BaseURL) {
            
            //Создаю реквест
            var urlRequest = URLRequest(url: url)
            
            //Указываю тип запроса GET, т.к. получаю данные с сайта
            urlRequest.httpMethod = "GET"
            
            //Указываю тип контента json
            urlRequest.setValue("application/json", forHTTPHeaderField: "content-Type")

            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                
                if let response = response {
                    print(response)
                }
                
                if let data = data {
                    let company = try! JSONDecoder().decode(Companies.self, from: data)
                    completion?(company)
                }
                
                if let error = error {
                    print(error)
                }
            }
            dataTask.resume()
        }
    }
    
}



