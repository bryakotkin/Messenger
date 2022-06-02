//
//  ConversationViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController {
    
    let model: IConversationModel
    let fetchController: NSFetchedResultsController<DBMessage>?
    let tableViewDataSource: ConversationTableViewDataSource
    
    var mainView: ConversationView? {
        return view as? ConversationView
    }
    
    init(model: IConversationModel) {
        self.model = model
        fetchController = model.getFetchController()
        tableViewDataSource = ConversationTableViewDataSource(
            frc: fetchController,
            model: model
        )
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden methods
    
    override func loadView() {
        view = ConversationView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        mainView?.delegate = self
        fetchController?.delegate = self
        
        do {
            try fetchController?.performFetch()
        } catch {
            print("Fetch Controller error:", error.localizedDescription)
        }
        
        model.listeningMessages()
        
        mainView?.tableView.dataSource = tableViewDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView?.updateTheme()
    }
}
