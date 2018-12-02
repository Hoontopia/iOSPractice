//
//  ViewController.swift
//  SplitViewPractice
//
//  Created by 임성훈 on 02/12/2018.
//  Copyright © 2018 임성훈. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout!
    
    private var dataList: [OGData] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowLayout.itemSize = CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
        
        let dropInteraction = UIDropInteraction(delegate: self)
        self.view.addInteraction(dropInteraction)
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: DataCell.self)
        let ogData = dataList[indexPath.item]
        
        guard let dataCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? DataCell else {
            return DataCell()
        }
        
        dataCell.prepare(title: ogData.title,
                         description: ogData.description,
                         imageURL: ogData.imageURL,
                         addtionalInfo: ogData.url?.absoluteString)
        
        return dataCell
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let identifier = String(describing: DataCell.self)

        guard let dataCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? DataCell else {
            return
        }
        
        dataCell.cancelImageDownload()
    }
}

// MARK: - UIDropInteractionDelegate

extension ViewController: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let operation: UIDropOperation
        operation = session.localDragSession == nil ? .copy : .move
        
        return UIDropProposal(operation: operation)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSURL.self, completion: { [weak self] result in
            guard let `self` = self else {
                return
            }
            
            guard let targetUrl = result.first as? NSURL else {
                return
            }
            
            if let data = OGData.ogData(from: targetUrl as URL) {
                self.dataList.append(data)
            }
        })
    }
}
