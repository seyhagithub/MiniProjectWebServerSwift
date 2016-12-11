//
//  PageController.swift
//  MiniProjectWebServer
//
//  Created by Hiem Seyha on 12/10/16.
//  Copyright © 2016 seyha. All rights reserved.
//

import UIKit

class PageController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    lazy var VCArray: [UIViewController]  = {
    
        return [self.VCInstance(name: "FilterVC"),
                self.VCInstance(name: "ManipluateVC"),
                self.VCInstance(name: "DoneVC")]
    }()
    
    private func VCInstance(name: String) -> UIViewController {
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        if let firstVC = VCArray.first {
            
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                
                view.frame = UIScreen.main.bounds
                
            } else if view is UIPageControl {
                
                view.backgroundColor = UIColor.clear
            }
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = VCArray.index(of: viewController) else {
            
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            
            return VCArray.last
        }
        
        guard VCArray.count > previousIndex else {
            
            return nil
        }
        
        return VCArray[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = VCArray.index(of: viewController) else {
            
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < VCArray.count else {
            
            return VCArray.first
        }
        
        guard VCArray.count > nextIndex else {
            
            return nil
        }
        
        return VCArray[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return VCArray.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = VCArray.index(of: firstViewController) else {
                
                return 0
        }
        
        return firstViewControllerIndex
    }

}
