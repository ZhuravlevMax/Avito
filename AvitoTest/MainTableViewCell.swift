//
//  MainTableViewCell.swift
//  AvitoTest
//
//  Created by Максим Журавлев on 29.09.22.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    //MARK: - Creating variables
    static let key = "MainTableViewCell"
    
    //MARK: - Creating items
    
    private lazy var mainView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var employeeNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var employeePhoneLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var employeeSkillsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(mainView)
        mainView.addSubview(employeeNameLabel)
        mainView.addSubview(employeePhoneLabel)
        mainView.addSubview(employeeSkillsLabel)
        
        updateViewConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func updateViewConstraints() {
        
        mainView.snp.makeConstraints {
            $0.left.bottom.right.top.equalToSuperview()
        }
        
        employeeNameLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(10)
        }
        
        employeePhoneLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.top.equalTo(employeeNameLabel.snp.bottom).offset(10)
        }
        
        employeeSkillsLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.top.equalTo(employeePhoneLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    func setValue(name: String, skills: String, phone: String ) {
        employeeNameLabel.text = name
        employeePhoneLabel.text = phone
        employeeSkillsLabel.text = skills
    }

}
