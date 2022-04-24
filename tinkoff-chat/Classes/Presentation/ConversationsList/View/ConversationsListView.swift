//
//  ConversationsListView.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import UIKit

class ConversationsListView: UIView {
    
    let tableView: UITableView = {
        let view = UITableView()
        view.register(ConversationListCell.self, forCellReuseIdentifier: Constants.conversationCell.rawValue)
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
        
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
