//
//  MeasurementTableViewCell.swift
//  SBRA
//
//  Created by Wander Siemers on 17/02/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import UIKit

enum MeasurementTableViewCellImageStyle {
	case noImage
	case image
}

class MeasurementTableViewCell: UITableViewCell {
	
	var userImageView: UIImageView?
	var nameLabel: UILabel
	var dateLabel: UILabel
	var imageStyle: MeasurementTableViewCellImageStyle
	
	init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, imageStyle: MeasurementTableViewCellImageStyle) {
		nameLabel = UILabel()
		dateLabel = UILabel()
		self.imageStyle = imageStyle
		
		if imageStyle == .image {
			userImageView = UIImageView()
		}
		
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		if let userImageView = userImageView {
			userImageView.image = UIImage(named: "graphicon")
			userImageView.contentMode = .scaleAspectFill
			userImageView.clipsToBounds = true
			
			contentView.addSubview(userImageView)
		}
		
		nameLabel.text = "Meting in Rotterdam-Noord"
		dateLabel.text = "28 oktober 2018"
		
		contentView.addSubview(nameLabel)
		contentView.addSubview(dateLabel)
		
		setupConstraints(imageStyle: imageStyle)
	}
	
	override convenience init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		self.init(style: style, reuseIdentifier: reuseIdentifier, imageStyle: .noImage)
	}
	
	private func setupConstraints(imageStyle: MeasurementTableViewCellImageStyle) {
		
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		
		if let userImageView = userImageView {
			userImageView.translatesAutoresizingMaskIntoConstraints = false
			
			NSLayoutConstraint.activate([
				userImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
				userImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
				userImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
				
				nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: userImageView.bottomAnchor, multiplier: 2.0)
			])
		} else {
			NSLayoutConstraint.activate([
				nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2.0)
			])
		}
		
		NSLayoutConstraint.activate([
			nameLabel.leftAnchor.constraint(equalToSystemSpacingAfter: contentView.leftAnchor, multiplier: 1.0),
			
			dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1.0),
			dateLabel.leftAnchor.constraint(equalToSystemSpacingAfter: contentView.leftAnchor, multiplier: 1.0),
			dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0)
		])
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
