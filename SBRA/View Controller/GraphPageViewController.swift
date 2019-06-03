//
//  GraphPageViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 28/11/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import UIKit
import simd

class GraphPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
	
	var motionDataParser = MotionDataParser()
	var graphViewControllers = [GraphViewController]()
	var initiallyVisibleGraphType = GraphType.speedTime
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		graphViewControllers = GraphType.allCases.map { (graphType) -> GraphViewController in
			let graphVC = GraphViewController(graphType: graphType, settings: motionDataParser.settings)
			return graphVC
		}
		
		view.backgroundColor = UIColor.white
		
		if let graphVC = graphViewControllers.filter({$0.graphType == initiallyVisibleGraphType }).first {
			setViewControllers([graphVC], direction: .forward, animated: true, completion: nil)
			title = graphVC.graphType.description
		}
		dataSource = self
		delegate = self
		
		// Do any additional setup after loading the view.
	}
	
	func pageViewController(_ pageViewController: UIPageViewController,
							viewControllerBefore viewController: UIViewController) -> UIViewController? {
		if let graphVC = viewController as? GraphViewController {
			if let index = graphViewControllers.firstIndex(of: graphVC), index > 0 {
				return graphViewControllers[index - 1]
			}
		}
		
		return nil
	}
	
	func pageViewController(_ pageViewController: UIPageViewController,
							viewControllerAfter viewController: UIViewController) -> UIViewController? {
		if let graphVC = viewController as? GraphViewController {
			if let index = graphViewControllers.firstIndex(of: graphVC), index < GraphType.allCases.count - 1 {
				return graphViewControllers[index + 1]
			}
		}
		
		return nil
	}
	
	func pageViewController(_ pageViewController: UIPageViewController,
							didFinishAnimating finished: Bool,
							previousViewControllers: [UIViewController],
							transitionCompleted completed: Bool) {
		let previous = previousViewControllers.first as? GraphViewController
		previous?.motionDataParser.stopDataCollection()
		
		if let graphType = (pageViewController.viewControllers?.first as? GraphViewController)?.graphType {
			title = graphType.description
		}
	}
	
	init() {
		super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
