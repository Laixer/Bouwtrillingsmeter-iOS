//
//  MeasureViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 25/11/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import UIKit

class MeasureViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var collectionView: UICollectionView
	let numberOfGraphs = 5
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.white
		
		navigationItem.title = "Meting"
		
		let saveButton = UIBarButtonItem(title: "Sla op", style: .done, target: self, action: #selector(tappedSaveButton))
		navigationItem.rightBarButtonItem = saveButton
		
		
		setupCollectionView()
		let motionDataParser = MotionDataParser()
		motionDataParser.startDataCollection(updateInterval: 0.1) { (dataPoint, error) in
			for i in 0...4 {
				if let cell = self.collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? GraphCollectionViewCell {
					if let acceleration = dataPoint?.acceleration {
						cell.addValues(values: [acceleration.x, acceleration.y, acceleration.z])
						//graphView.add([acceleration.x, acceleration.y, acceleration.z])
					}
				}
			}
		}
		
		
		// Do any additional setup after loading the view.
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return numberOfGraphs
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GraphCollectionViewCell
		cell.backgroundColor = UIColor.rotterdamGreen
		cell.layer.cornerRadius = 8.0
		cell.text = GraphType.allCases[indexPath.row].description
		return cell
		
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let graphPageViewController = GraphPageViewController()
		graphPageViewController.initiallyVisibleGraphType = GraphType.allCases[indexPath.row]
		navigationController?.pushViewController(graphPageViewController, animated: true)
	}
	
	private func setupCollectionView() {
		collectionView.frame = view.bounds
		collectionView.dataSource = self
		collectionView.delegate = self
		view.addSubview(collectionView)
		
		collectionView.reloadData()
		collectionView.backgroundColor = UIColor.white
		if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			layout.minimumInteritemSpacing = 22
			layout.minimumLineSpacing = 22
			layout.itemSize = CGSize(width: 153, height: 168)
			layout.sectionInset = UIEdgeInsets(top: 22, left: 22, bottom: 22, right: 22)
		}
		
		collectionView.register(GraphCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
	}
	
	@objc private func tappedSaveButton() {
		self.presentingViewController?.dismiss(animated: true, completion: nil)
	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
