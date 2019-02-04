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
		motionDataParser.startDataCollection(updateInterval: 0.02) { (dataPoint, error) in
			for i in 0..<self.collectionView.numberOfItems(inSection: 0) {
				let indexPath = IndexPath(row: i, section: 0)
				if let cell = self.collectionView.cellForItem(at: indexPath) as? GraphCollectionViewCell, let dataPoint = dataPoint {
					self.updateCell(cell: cell, at: indexPath, with: dataPoint)
				}
			}
		}
	}
	
	private func updateCell(cell: GraphCollectionViewCell, at indexPath: IndexPath, with dataPoint: DataPoint) {
		switch indexPath.row {
		case 0:
			cell.addValues(values: [Double(dataPoint.speed), 0, 0])
		case 1:
			if let dominantFrequency = dataPoint.dominantFrequency {
				cell.addValues(values: [Double(dominantFrequency.x.frequency) / 100.0, Double(dominantFrequency.y.frequency) / 100.0, Double(dominantFrequency.z.frequency) / 100.0])
			}
		case 3:
			cell.graphView.clear()
			if let fft = dataPoint.fft {
				for element in fft {
					cell.addValues(values: [Double(element * 100.0), 0, 0])
				}
			}
		case 4:
			cell.addValues(values: [dataPoint.acceleration.x,
									dataPoint.acceleration.y,
									dataPoint.acceleration.z
				/*, gravity.x, gravity.y, gravity.z*/])
			
			
		default: break
			
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return numberOfGraphs
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GraphCollectionViewCell
		cell.backgroundColor = UIColor.rotterdamGreen
		cell.layer.cornerRadius = 8.0
		cell.text = GraphType.allCases[indexPath.row].description
		/*if (indexPath.row == 0) {
			cell.graphView.numberOfLines = 1
		} else if (indexPath.row == 4) {
			cell.graphView.numberOfLines = 6
		} else if (indexPath.row == 2) {
			cell.graphView.numberOfLines = 0
		} else {
			cell.graphView.numberOfLines = 3
		}*/
		if (indexPath.row == 0) {
			cell.graphView.singleLine = true
		}
		
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
			layout.itemSize = CGSize(width: 120, height: 168)
			layout.sectionInset = UIEdgeInsets(top: 22, left: 22, bottom: 22, right: 22)
		}
		
		collectionView.register(GraphCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
	}
	
	@objc private func tappedSaveButton() {
		self.presentingViewController?.dismiss(animated: true, completion: nil)
	}
}
