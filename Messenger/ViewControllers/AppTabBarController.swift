//
//  AppTabBarController.swift
//  Messenger
//
//  Created by didYouUpdateCode on 2017/4/26.
//  Copyright © 2017年 didYouUpdateCode. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController {
    
    enum Item {
        case recent, call, group, people, settings
        
        var title: String {
            switch self {
            case .recent:
                return "Recent"
            case .call:
                return "Call"
            case.group:
                return "Group"
            case .people:
                return "People"
            case .settings:
                return "Settings"
            }
        }
        
        var imageName: String {
            switch self {
            case .recent:
                return "recent"
            case .call:
                return "calls"
            case .group:
                return "groups"
            case .people:
                return "people"
            case .settings:
                return "settings"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [createViewController(withItem: .recent),
                           createViewController(withItem: .call),
                           createViewController(withItem: .group),
                           createViewController(withItem: .people),
                           createViewController(withItem: .settings)]
    }
    
    private func createViewController(withItem item: Item) -> UIViewController {
        var viewController: UIViewController!
        
        switch item {
        case .recent:
            viewController = UINavigationController(rootViewController: RecentViewController())
            
        default:
            viewController = UINavigationController(rootViewController: UIViewController())
        }
        
        viewController.tabBarItem.title = item.title
        viewController.tabBarItem.image = UIImage(named: item.imageName)
        
        return viewController
    }
}
