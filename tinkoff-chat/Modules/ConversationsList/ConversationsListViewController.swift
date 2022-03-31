//
//  ConversationsListViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    var channels: Channels = []
    let sectionName = "Channels"
    let firebaseManager = (UIApplication.shared.delegate as? AppDelegate)?.firebaseManager
    
    var mainView: ConversationsListView? {
        return view as? ConversationsListView
    }
    
    override func loadView() {
        self.view = ConversationsListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tinkoff Chat"
        
        mainView?.tableView.delegate = self
        mainView?.tableView.dataSource = self
        
        fetchChannels()
        setupNavigationItem()
        updateTheme()
    }
    
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
}

// MARK: - Firebase logic

extension ConversationsListViewController {
    func fetchChannels() {
        firebaseManager?.listeningChannels { [weak self] channels in
            self?.channels = channels
            self?.mainView?.tableView.reloadData()
        }
    }
}

// MARK: - ConversationsListViewController: UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = channels[indexPath.row]
        
        let conversationVC = ConversationViewController()
        conversationVC.title = model.name
        conversationVC.channel = model
        
        navigationController?.pushViewController(conversationVC, animated: true)
        mainView?.tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - ConversationsListViewController: UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.conversationCell.rawValue,
            for: indexPath
        ) as? ConversationListCell else { return UITableViewCell() }
        
        let channel = channels[indexPath.row]
        
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
