//
//  ConversationsListViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import UIKit
import CoreData

class ConversationsListViewController: UIViewController {
    
    let fetchController: NSFetchedResultsController<DBChannel>?

    let model: IConversationsListModel
    
    // MARK: - TableView properties
    
    let tableViewDataSource: ConversationsListTableViewDataSource
    let tableViewDelegate: ConversationsListTableViewDelegate
    
    var mainView: ConversationsListView? {
        return view as? ConversationsListView
    }
    
    init(_ model: IConversationsListModel) {
        self.model = model
        self.fetchController = model.getFetchController()
        self.tableViewDataSource = ConversationsListTableViewDataSource(
            frc: fetchController
        )
        self.tableViewDelegate = ConversationsListTableViewDelegate()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden methods
    
    override func loadView() {
        self.view = ConversationsListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tinkoff Chat"
        
        tableViewDelegate.delegate = self
        
        mainView?.tableView.delegate = tableViewDelegate
        mainView?.tableView.dataSource = tableViewDataSource
        
        model.listeningChannels()
        
        setupNavigationItem()
        updateTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchController?.delegate = self
        
        do {
            try fetchController?.performFetch()
            mainView?.tableView.reloadData()
        } catch {
            print("Fetch error:", error.localizedDescription)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fetchController?.delegate = nil
    }
    
    // MARK: - Views configuration
    
    private func setupNavigationItem() {
        var profileButton = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(showProfileVC))
        var settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showThemesVC))
        
        if let profileImage = UIImage(systemName: "person") {
            profileButton = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(showProfileVC))
        }
        if let settingsImage = UIImage(systemName: "gearshape") {
            settingsButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(showThemesVC))
        }
        let addChannelButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewChannelAlert))
        
        navigationItem.leftBarButtonItem = settingsButton
        navigationItem.setRightBarButtonItems([profileButton, addChannelButton], animated: false)
    }
    
    func updateTheme() {
        let theme = model.getTheme()
        
        UITableView.appearance().backgroundColor = theme?.backgroundColor
        UITableViewHeaderFooterView.appearance().tintColor = theme?.backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = theme?.labelColor
        navigationController?.navigationBar.barTintColor = theme?.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: theme?.titleControllerColor ?? .black
        ]
        
        mainView?.tableView.reloadData()
    }
    
    // MARK: - Swipe actions
    
    func removeChannelSwipeAction(_ indexPath: IndexPath) {
        guard let channel = tableViewDataSource.fetchChannel(by: indexPath) else { return }
        
        model.deleteChannel(channel: channel)
    }
}

// MARK: - ConversationsListViewController: UIViewController logic

extension ConversationsListViewController {
    @objc private func showProfileVC() {
        let profileVC = PresentationAssembly.profileViewController
        profileVC.title = "My Profile"
        let navigationVC = UINavigationController(rootViewController: profileVC)
        
        show(navigationVC, sender: self)
    }
    
    @objc private func showThemesVC() {
        let themesVC = PresentationAssembly.themeViewController
        themesVC.title = "Settings"
        themesVC.delegate = self
        
        themesVC.onComplition = { [weak self] theme in
            self?.model.saveTheme(theme)
            self?.updateTheme()
        }
        
        show(themesVC, sender: self)
    }
    
    @objc private func showNewChannelAlert() {
        let alertController = UIAlertController(title: "Создать канал", message: "Введите название канала", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Название"
        }
        
        let closeButtonAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: .none)
        let createButtonAction = UIAlertAction(title: "Создать", style: .default) { [weak self] _ in
            let textField = alertController.textFields?.first
            guard let name = textField?.text, !name.isBlank else { return }
            
            self?.model.createChannel(name: name)
        }
        
        alertController.addAction(closeButtonAction)
        alertController.addAction(createButtonAction)
        
        present(alertController, animated: true)
    }
}
