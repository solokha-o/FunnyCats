//
//  TapBarController.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 29.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit

class TapBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupTabBarItem()
    }
    
    // animate transition next controller by press tapbar
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let tabViewControllers = tabBarController.viewControllers, let toIndex = tabViewControllers.firstIndex(of: viewController) else {
            return false
        }
        animateToTab(toIndex: toIndex)
        return true
    }
    // animate transition view
    func animateToTab(toIndex: Int) {
        guard let tabViewControllers = viewControllers,
            let selectedVC = selectedViewController else { return }
        guard let fromView = selectedVC.view,
            let toView = tabViewControllers[toIndex].view,
            let fromIndex = tabViewControllers.firstIndex(of: selectedVC),
            fromIndex != toIndex else { return }
        // Add the toView to the tab bar view
        fromView.superview?.addSubview(toView)
        // Position toView off screen (to the left/right of fromView)
        let screenWidth = UIScreen.main.bounds.size.width
        let scrollRight = toIndex > fromIndex
        let offset = (scrollRight ? screenWidth : -screenWidth)
        toView.center = CGPoint(x: fromView.center.x + offset, y: toView.center.y)
        // Disable interaction during animation
        view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        // Slide the views by -offset
                        fromView.center = CGPoint(x: fromView.center.x - offset, y: fromView.center.y)
                        toView.center = CGPoint(x: toView.center.x - offset, y: toView.center.y)
        }, completion: { finished in
            // Remove the old view from the tabbar view.
            fromView.removeFromSuperview()
            self.selectedIndex = toIndex
            self.view.isUserInteractionEnabled = true
        })
    }
    // setup title, image to each viewControllers tabBarItem and color to tabBar
    func setupTabBarItem() {
        self.viewControllers?[0].tabBarItem.title = "Cat breeds"
        self.viewControllers?[1].tabBarItem.title = "Guess Cat"
        self.viewControllers?[2].tabBarItem.title = "Cat gallery"
        self.viewControllers?[0].tabBarItem.image = UIImage(named: "Item1")
        self.viewControllers?[1].tabBarItem.image = UIImage(named: "Item2")
        self.viewControllers?[2].tabBarItem.image = UIImage(named: "Item3")
        self.tabBar.barTintColor = .systemTeal
    }
}
