//
//  ViewController.swift
//  AvitoTest
//
//  Created by Максим Журавлев on 29.09.22.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
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
        
        view.backgroundColor = .gray
        
        //MARK: - Add items to display
        view.addSubview(mainTableView)
        updateViewConstraints()
    }

    //MARK: - updateViewConstraints
    override func updateViewConstraints() {
        
        mainTableView.snp.makeConstraints {
            $0.left.bottom.right.top.equalToSuperview()
        }
        
        super.updateViewConstraints()
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = mainTableView.dequeueReusableCell(withIdentifier: MainTableViewCell.key, for: indexPath) as? MainTableViewCell {
            cell.backgroundColor = .red
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Company"
    }
}

