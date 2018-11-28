//
//  GraphPageViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 28/11/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import UIKit
import simd

class GraphPageViewController: UIPageViewController, UIPageViewControllerDataSource {
	
	var motionDataParser = MotionDataParser()
	var graphViewControllers = [GraphViewController]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		graphViewControllers = GraphType.allCases.map { (graphType) -> GraphViewController in
			return GraphViewController(graphType: graphType)
		}
		
		view.backgroundColor = UIColor.white
		
		setViewControllers([graphViewControllers.first!], direction: .forward, animated: true, completion: nil)
		dataSource = self
		
		
		// Do any additional setup after loading the view.
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		if let graphVC = viewController as? GraphViewController {
			if let index = graphViewControllers.firstIndex(of: graphVC), index > 0 {
				return graphViewControllers[index - 1]
			}
		}
		
		return nil
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		if let graphVC = viewController as? GraphViewController {
			if let index = graphViewControllers.firstIndex(of: graphVC), index < GraphType.allCases.count - 1 {
				return graphViewControllers[index + 1]
			}
		}
		
		return nil
	}
	
	init() {
		super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
