//
//  MainPresenter.swift
//  AvitoTest
//
//  Created by Максим Журавлев on 9.10.22.
//

import Foundation
import UIKit

protocol MainViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol)
    func downloadContent()
    var companies: Companies? {get set}
}

class MainPresenter: MainViewPresenterProtocol {
    
    var companies: Companies?
    weak var view: MainViewProtocol?
    let networkService: NetworkServiceProtocol
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        downloadContent()
    }
    
    func downloadContent() {
        NetworkService.shared.downloadContent(fromUrlString: "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c") { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let companies):
                    print(companies)
                    self.companies = companies
                    self.view?.success()
                    
                    
                case .failure( let error):
                    self.view?.failure(error: error)
                    
                }
            }
            
        }
    }
    
    
}
