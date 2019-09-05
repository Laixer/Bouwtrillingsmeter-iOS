//
//  AdvancedAppSettingsViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 16/06/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import UIKit

class AdvancedAppSettingsViewController: UITableViewController {
	
	private func sharedInit() {
		title = "Geavanceerde instellingen"
	}
	
	override init(style: UITableView.Style) {
		super.init(style: style)
		sharedInit()
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		sharedInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.rowHeight = 44.0
    }
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = SwitchTableViewCell(style: .default, reuseIdentifier: "cell")
		cell.textLabel?.text = "Toon grafieken"
		
		cell.switchElement.addTarget(self, action: #selector(toggleGraphs), for: .valueChanged)
		
		return cell
	}
	
	@objc func toggleGraphs(sender: UISwitch) {
		print(sender.isOn ? "Enabled graphs" : "Disabled graphs")
		UserDefaults.standard.set(sender.isOn, forKey: PreferencesKeys.enabledGraphsPreferenceKey)
	}
}
