//
//  ConversationsListViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 10.03.2022.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    let conversations = DataSourceManager.getConversations()
    let sections = ["Online", "History"]
    
    var mainView: ConversationsListView {
        return view as! ConversationsListView
    }
    
    override func loadView() {
        self.view = ConversationsListView()
    }
    
    override func viewDidLoad() {
        title = "Tinkoff Chat"
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        setupNavigationItem()
        updateTheme()
    }
    
    private func setupNavigationItem() {
        var profileButton: UIBarButtonItem?
        var settingsButton: UIBarButtonItem?
        
        if let profileImage = UIImage(systemName: "person") {
            profileButton = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(showProfileVC))
        }
        else {
            profileButton = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(showProfileVC))
        }
        
        if let settingsImage = UIImage(systemName: "gearshape") {
            settingsButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(showThemesVC))
        }
        else {
            settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showThemesVC))
        }
        
        navigationItem.rightBarButtonItem = profileButton
        navigationItem.leftBarButtonItem = settingsButton
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
    
    private func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        
        UITableView.appearance().backgroundColor = theme?.backgroundColor
        UITableViewHeaderFooterView.appearance().tintColor = theme?.backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = theme?.labelColor
        navigationController?.navigationBar.barTintColor = theme?.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: theme?.titleControllerColor ?? .black
        ]
        
        mainView.tableView.reloadData()
    }
}

// MARK: - ConversationsListViewController: UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = conversations[indexPath.section][indexPath.row]
        
        let conversationVC = ConversationViewController()
        conversationVC.title = model.name
        conversationVC.messages = model.messages
        
        navigationController?.pushViewController(conversationVC, animated: true)
        mainView.tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - ConversationsListViewController: UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.conversationCell.rawValue, for: indexPath) as? ConversationListCell else { return UITableViewCell() }
        
        let data = conversations[indexPath.section][indexPath.row]
        let message: Message? = data.messages?.last
        
        let model = ConversationListCellModel(
            name: data.name,
            message: message?.text,
            date: message?.date,
            online: data.online,
            hasUnreadMessages: data.hasUnreadMessages
        )
        
        cell.configure(model: model)
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

