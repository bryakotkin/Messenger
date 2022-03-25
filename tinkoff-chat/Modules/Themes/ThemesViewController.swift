//
//  ThemesViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 17.03.2022.
//

import UIKit

protocol ThemesPickerDelegate: AnyObject {
    func configureTheme(_ theme: Themes)
}

class ThemesViewController: UIViewController {
    
    // В случае если бы класс ConversationListVC имел ссылку на ThemesVC и наоборот, то есть на друг друга и ссылки были бы сильные, то мог бы возникнуть RetainCycle. В данном случае такого быть не может.
    
    var onComplition: ((Themes) -> ())?
    weak var delegate: ThemesPickerDelegate?
    
    var mainView: ThemesView {
        return view as! ThemesView
    }
    
    override func loadView() {
        view = ThemesView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.delegate = self
    }
}

// MARK: - ThemesViewController: ThemeViewDelegate

extension ThemesViewController: ThemeViewDelegate {
    
    func viewTapped(_ theme: Themes) {
//        delegate?.configureTheme(theme)
        onComplition?(theme)
    }
}
