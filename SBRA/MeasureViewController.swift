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

        // Do any additional setup after loading the view.
    }
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return numberOfGraphs
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
		cell.backgroundColor = UIColor.green
		cell.layer.cornerRadius = 8.0
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
