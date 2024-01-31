//
//  TabBarViewController.swift
//  photoEditor
//
//  Created by Alina Titarenko on 05.12.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
    }
    
    private func generateTabBar() {
        viewControllers = [
            generateVC(viewController: FilterPhotoView(viewModel: FilterPhotoViewModel()), title: "Filter", image: UIImage(systemName: "camera.filters")!),
            generateVC(viewController: LibaryViewController(viewModel: LibaryViewModel()), title: "Libary", image: UIImage(systemName: "photo.on.rectangle")!)
        ]
        
        
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image

        return viewController
    }
}

