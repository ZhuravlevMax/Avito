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
    var presenter: MainViewPresenterProtocol?
    
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
        makeRefresher()
    }

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
        presenter?.downloadContent()
        mainTableView.reloadData()
        sender.endRefreshing()
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource, MainViewProtocol {
    
    func success() {
        mainTableView.reloadData()
    }
    
    func failure( error: Error) {
        let error = error as? URLError
        if error?.code == URLError.notConnectedToInternet {
            print("No internet connection!")
            let alertController = UIAlertController(title: "Oops!", message: "Check your internet connection.", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
            let refreshButton = UIAlertAction(title: "Refresh", style: .default) { [weak self]_ in
                guard let self = self else {return}
                self.presenter?.downloadContent()
                self.mainTableView.reloadData()
                
            }
            DispatchQueue.main.async {
                alertController.addAction(refreshButton)
                alertController.addAction(cancelButton)
                self.present(alertController, animated: true)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.companies?.company.employees.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = mainTableView.dequeueReusableCell(withIdentifier: MainTableViewCell.key, for: indexPath) as? MainTableViewCell {
            cell.backgroundColor = .white
            if let employee = presenter?.companies?.company.employees.sorted(by: { $0.name < $1.name}) {
                cell.setValue(name: "Name: \(employee[indexPath.row].name)",
                              skills: "Skills: \(employee[indexPath.row].skills.joined(separator: "; "))",
                              phone: "Phone: \(employee[indexPath.row].phoneNumber)")
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let titleHeader = presenter?.companies?.company.name {
            return titleHeader
        }
        return ""
    }
}

