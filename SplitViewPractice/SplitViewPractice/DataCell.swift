//
//  DataCell.swift
//  SplitViewPractice
//
//  Created by 임성훈 on 02/12/2018.
//  Copyright © 2018 임성훈. All rights reserved.
//

import UIKit
import Kingfisher

class DataCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var addtionalInfoLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Setup Methods
    
    func prepare(title: String?,
                 description: String?,
                 imageURL: URL?,
                 addtionalInfo: String?) {
        titleLabel.text = title
        descriptionLabel.text = description
        addtionalInfoLabel.text = addtionalInfo
        
        if let imageURL = imageURL {
            imageView.kf.setImage(with: imageURL)
        }
    }
    
    func cancelImageDownload() {
        imageView.kf.cancelDownloadTask()
    }
}
