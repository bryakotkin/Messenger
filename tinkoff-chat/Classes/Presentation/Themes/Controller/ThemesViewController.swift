//
//  ThemesViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 17.03.2022.
//

import UIKit

protocol ThemesPickerDelegate: AnyObject {
    func fetchCurrentTheme() -> Theme?
}

class ThemesViewController: UIViewController {
    
    var onComplition: ((Theme) -> Void)?
    weak var delegate: ThemesPickerDelegate?
    
    var mainView: ThemesView? {
        return view as? ThemesView
    }
    
    override func loadView() {
        view = ThemesView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView?.updateTheme()
    }
}

// MARK: - ThemesViewController: ThemeViewDelegate

extension ThemesViewController: ThemeViewDelegate {
    func fetchCurrentTheme() -> Theme? {
        delegate?.fetchCurrentTheme()
    }
    
    func viewTapped(_ theme: Theme) {
        onComplition?(theme)
    }
}
