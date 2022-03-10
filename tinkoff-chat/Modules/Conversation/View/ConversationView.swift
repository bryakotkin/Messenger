//
//  ConversationView.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import UIKit

class ConversationView: UIView {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ConversationViewCell.self, forCellReuseIdentifier: Constants.conversationCell.rawValue)
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.separatorColor = .clear
        
        addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
