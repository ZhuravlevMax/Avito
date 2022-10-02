//
//  ViewController.swift
//  AvitoTest
//
//  Created by Максим Журавлев on 29.09.22.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    //MARK: - Creating variables
    private var companyName: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    }
    private var employees: [Employee] = [] {
        didSet {
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    }
    private var skills: String?
    
    //MARK: - Сreating items
    private lazy var mainTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.key)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 68
        
        return tableView
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        //MARK: - Add items to display
        view.addSubview(mainTableView)
        
        updateViewConstraints()
        getData()
        makeRefresher()
    }
    
    //MARK: - Method for loading data
    private func getData() {
        APIManager.shared.downloadContent(fromUrlString: "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c") { result in
            switch result {
            case .success(let company):
                print(company)
                self.companyName = company.company.name
                self.employees = company.company.employees.sorted(by: { $0.name < $1.name})

            case .failure( let error):
                if error.code == URLError.notConnectedToInternet {
                    print("No internet connection!")
                    let alertController = UIAlertController(title: "Oops!", message: "Check your internet connection.", preferredStyle: .alert)
                    let refreshButton = UIAlertAction(title: "Refresh", style: .default) {_ in
                        self.getData()
                        self.mainTableView.reloadData()

                    }
                    DispatchQueue.main.async {
                        alertController.addAction(refreshButton)
                        self.present(alertController, animated: true)
                    }

                }
                
            }
        }
    }
    
    //    private func getData() {
    //        APIManager.shared.getCompany { [weak self] result in
    //            guard let self = self else {return}
    //
    //            switch result {
    //            case .success( let company):
    //                self.companyName = company.company.name
    //                self.employees = company.company.employees.sorted(by: { $0.name < $1.name})
    //
    //            case .failure( let error):
    //                if error.code == URLError.notConnectedToInternet {
    //                    print("No internet connection!")
    //                    let alertController = UIAlertController(title: "Oops!", message: "Check your internet connection.", preferredStyle: .alert)
    //                    let refreshButton = UIAlertAction(title: "Refresh", style: .default) {_ in
    //                        self.getData()
    //                        self.mainTableView.reloadData()
    //
    //                    }
    //                    DispatchQueue.main.async {
    //                        alertController.addAction(refreshButton)
    //                        self.present(alertController, animated: true)
    //                    }
    //
    //                }
    //
    //            }
    //        }
    //    }
    
    //MARK: - updateViewConstraints
    override func updateViewConstraints() {
        
        mainTableView.snp.makeConstraints {
            $0.left.bottom.right.top.equalToSuperview()
        }
        
        super.updateViewConstraints()
    }
    
    //MARK: - Refresher for mainTableView
    func makeRefresher() {
        
        let refresh = UIRefreshControl()
        mainTableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refresher(sender: )), for: .valueChanged)
    }
    
    @objc private func refresher(sender: UIRefreshControl) {
        getData()
        mainTableView.reloadData()
        sender.endRefreshing()
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = mainTableView.dequeueReusableCell(withIdentifier: MainTableViewCell.key, for: indexPath) as? MainTableViewCell {
            cell.backgroundColor = .white
            cell.setValue(name: "Name: \(employees[indexPath.row].name)",
                          skills: "Skills: \(employees[indexPath.row].skills.joined(separator: "; "))",
                          phone: "Phone: \(employees[indexPath.row].phoneNumber)")
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        companyName
    }
}

