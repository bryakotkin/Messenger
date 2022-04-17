//
//  ConversationsListViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import UIKit
import CoreData

class ConversationsListViewController: UIViewController {
    
    let sectionName = "Channels"
    let firebaseManager = (UIApplication.shared.delegate as? AppDelegate)?.firebaseManager
    
    lazy var fetchController: NSFetchedResultsController<DBChannel> = {
        let context = CoreDataStack.shared.service.readContext
        let fetchRequest = DBChannel.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(DBChannel.lastActivity), ascending: false)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        return controller
    }()
    
    var mainView: ConversationsListView? {
        return view as? ConversationsListView
    }
    
    // MARK: - Overridden methods
    
    override func loadView() {
        self.view = ConversationsListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tinkoff Chat"
        
        mainView?.tableView.delegate = self
        mainView?.tableView.dataSource = self
        
        firebaseManager?.listeningChannels()
        
        setupNavigationItem()
        updateTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchController.delegate = self
        
        do {
            try fetchController.performFetch()
            mainView?.tableView.reloadData()
        } catch {
            print("Fetch error:", error.localizedDescription)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fetchController.delegate = nil
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
    
    private func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        
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
    
    private func removeChannelSwipeAction(_ indexPath: IndexPath) {
        let dbChannel = fetchController.object(at: indexPath)
        guard let channel = Channel(dbModel: dbChannel) else { return }
        
        firebaseManager?.deleteChannel(channel: channel)
    }
}

// MARK: - ConversationsListViewController: UIViewController logic

extension ConversationsListViewController {
    @objc private func showProfileVC() {
        let profileVC = ProfileViewController()
        profileVC.title = "My Profile"
        let navigationVC = UINavigationController(rootViewController: profileVC)
        
        show(navigationVC, sender: self)
    }
    
    @objc private func showThemesVC() {
        let themesVC = ThemesViewController()
        themesVC.title = "Settings"
        themesVC.delegate = self
        
        themesVC.onComplition = { [weak self] theme in
            ThemeManager.shared.saveCurrentTheme(theme)
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
            
            self?.firebaseManager?.createChannel(name: name)
        }
        
        alertController.addAction(closeButtonAction)
        alertController.addAction(createButtonAction)
        
        present(alertController, animated: true)
    }
}

// MARK: - ConversationsListViewController: UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = fetchController.object(at: indexPath)
        let model = Channel(dbModel: object)
        
        let conversationVC = ConversationViewController()
        conversationVC.title = model?.name
        conversationVC.channel = model
        
        navigationController?.pushViewController(conversationVC, animated: true)
        mainView?.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { [weak self] _, _, completionHandler in
            self?.removeChannelSwipeAction(indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - ConversationsListViewController: UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchController.sections else { return 0 }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.conversationCell.rawValue,
            for: indexPath
        ) as? ConversationListCell else { return UITableViewCell() }
        
        let object = fetchController.object(at: indexPath)
        guard let channel = Channel(dbModel: object) else { return UITableViewCell() }
        
        cell.configure(model: channel)
        cell.updateTheme()
        
        return cell
    }
}

// MARK: - ConversationsListViewController: ThemesPickerDelegate

extension ConversationsListViewController: ThemesPickerDelegate {
    func configureTheme(_ theme: Themes) {
        ThemeManager.shared.saveCurrentTheme(theme)
        updateTheme()
    }
}

// MARK: - ConversationsListViewController: NSFetchedResultsControllerDelegate

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        mainView?.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        mainView?.tableView.endUpdates()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }

            mainView?.tableView.insertRows(at: [newIndexPath], with: .none)
        case .delete:
            guard let indexPath = indexPath else { return }

            mainView?.tableView.deleteRows(at: [indexPath], with: .none)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }

            mainView?.tableView.deleteRows(at: [indexPath], with: .none)
            mainView?.tableView.insertRows(at: [newIndexPath], with: .none)
        case .update:
            guard let indexPath = indexPath else { return }

            mainView?.tableView.reloadRows(at: [indexPath], with: .none)
        @unknown default:
            return
        }
    }
}
