//
//  PageViewController.swift
//  flatfindingmanager
//
//  Created by Ladislav Szolik on 19.12.18.
//  Copyright © 2018 Ladislav Szolik. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource{

    var images = [UIImage]()
    var currentIndexFromParent: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = .black
        
        view.backgroundColor = .black
        setupFirstItem()
    }
    
    func setupFirstItem() {
        
        if images.count > 0 {
            let firstController: ItemViewController = getItemController(currentIndexFromParent)!
            let startingControllers = [firstController]
            setViewControllers(startingControllers, direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        }
    }
    
    
    func getItemController(_ itemIndex: Int) -> ItemViewController? {
        if itemIndex < images.count {
            let pageItemController = self.storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
            pageItemController.itemIndex = itemIndex
            pageItemController.image = images[itemIndex]
            return pageItemController
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! ItemViewController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! ItemViewController
        
        if itemController.itemIndex + 1 < images.count {
            return getItemController(itemController.itemIndex + 1)
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return images.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndexFromParent
    }
    

  

}
