//
//  AppDelegate.swift
//  SBRA
//
//  Created by Wander Siemers on 21/10/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.tintColor = UIColor.rotterdamGreen
		
		let viewController = MeasurementsViewController()
		let navController = UINavigationController(rootViewController: viewController)
		window?.rootViewController = navController
		
		window?.makeKeyAndVisible()
		
		return true
	}
}
