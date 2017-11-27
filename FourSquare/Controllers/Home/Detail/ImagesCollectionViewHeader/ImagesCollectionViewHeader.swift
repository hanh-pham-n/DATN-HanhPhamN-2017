//
//  ImagesCollectionViewHeader.swift
//  FourSquare
//
//  Created by Duy Linh on 5/3/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit

class ImagesCollectionViewHeader: UITableViewHeaderFooterView {
    
    // MARK: Properties
    @IBOutlet fileprivate weak var imagesCollectionView: UICollectionView!
    @IBOutlet private weak var imagesPageControl: UIPageControl!
    var photos: [Photo] = [] {
        didSet {
            imagesPageControl.numberOfPages = photos.count
            imagesCollectionView.reloadData()
        }
    }
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    // MARK: Private
    private func setupCollectionView() {
        imagesCollectionView.register(ImagesCollectionViewCell.self)
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
    }
    
    fileprivate func scrollToCellAtIndex(index: Int, animated: Bool) {
        let indexPath: IndexPath = IndexPath(row: index, section: 0)
        imagesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        imagesPageControl.currentPage = index
    }
    
    fileprivate func indexCollection() -> Int {
        let contentOffsetX = imagesCollectionView.contentOffset.x
        let contentWidth = imagesCollectionView.bounds.width
        let index = Int(contentOffsetX / contentWidth)
        return index
    }
}

// MARK: UIScrollViewDelegate
extension ImagesCollectionViewHeader: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToCellAtIndex(index: indexCollection(), animated: true)
    }
}

// MARK: UICollectionViewDataSource
extension ImagesCollectionViewHeader: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ImagesCollectionViewCell.self, forIndexPath: indexPath)
        cell.setupData(photo: photos[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ImagesCollectionViewHeader: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return imagesCollectionView.frame.size
    }
}
