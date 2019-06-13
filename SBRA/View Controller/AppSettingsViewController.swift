//
//  AppSettingsViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 13/06/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import UIKit

class AppSettingsViewController: UIViewController {
	let tableView = UITableView(frame: .zero)
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		
		view.addSubview(tableView)
		setupTableView()
	}
	
	private func setupTableView() {
		view.translatesAutoresizingMaskIntoConstraints = false
		
		view.addConstraints([
			tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		
		/*let button = UIButton()
		button.setTitle("Geavanceerde opties", for: .normal)
		view.addSubview(button)
		
		button.translatesAutoresizingMaskIntoConstraints = false
		view.addConstraints([
			//button.topanch
			])*/
	}
}
