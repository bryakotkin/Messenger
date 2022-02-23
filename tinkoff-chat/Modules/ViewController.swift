//
//  ViewController.swift
//  tinkoff-chat
//
//  Created by Nikita on 17.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.printViewControllerStatus(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Logger.printViewControllerStatus(#function)
    }
    
    override func viewWillLayoutSubviews() {
        Logger.printViewControllerStatus(#function)
    }
    
    override func viewDidLayoutSubviews() {
        Logger.printViewControllerStatus(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Logger.printViewControllerStatus(#function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Logger.printViewControllerStatus(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Logger.printViewControllerStatus(#function)
    }
}

