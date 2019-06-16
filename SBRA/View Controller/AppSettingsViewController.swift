//
//  AppSettingsViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 13/06/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import UIKit

class AppSettingsViewController: UITableViewController {
	
	private func sharedInit() {
		title = "Instellingen"
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
															target: self,
															action: #selector(dismissTapped))
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		sharedInit()
	}
	
	override init(style: UITableView.Style) {
		super.init(style: style)
		sharedInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
		
		cell.textLabel?.text = "Geavanceerde instellingen"
		cell.accessoryType = .disclosureIndicator
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		navigationController?.pushViewController(AdvancedAppSettingsViewController(style: .grouped), animated: true)
	}
	
	@objc private func dismissTapped() {
		presentingViewController?.dismiss(animated: true, completion: nil)
	}
}
