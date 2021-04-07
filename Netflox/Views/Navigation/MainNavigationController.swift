//
//  MainNavigationController.swift
//  MovieSearch
//
//  Created by Guillem Budia Tirado on 31/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import UIKit

/// Encapsulates the features for the main navigation controllers. Now it handles the LargeTitle feature
class MainNavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {
        rootViewController.navigationItem.largeTitleDisplayMode = .always
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.prefersLargeTitles = true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        updateLargeTitles(in: viewController)
    }
    
    private func updateLargeTitles(in vc: UIViewController?) {
        
        let mode = viewControllers.count < 2 ?
            UINavigationItem.LargeTitleDisplayMode.always :
            UINavigationItem.LargeTitleDisplayMode.never
        
        vc?.navigationItem.largeTitleDisplayMode = mode
    }
}
