//
//  SuperHeroViewController+Collection.swift
//  ConsultrTest
//
//  Created by Alexander Bukov on 22/05/2021.
//

import Foundation
import UIKit
import SDWebImage

extension SuperHeroViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionDataProvider.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionDataProvider.sections[section] {
        case .items(let medias):
            return medias.count
        case .loadMore:
            return 1
        case .empty:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionDataProvider.sections[indexPath.section] {
        case .items(let medias):
            let media = medias[indexPath.item]
            let cell = collectionView.dequeueCell(indexPath: indexPath,
                                                  cellType: MediaCell.self)
            
            configure(cell, model: media, indexPath: indexPath)
            
            return cell
        case .loadMore:
            let cell = collectionView.dequeueCell(indexPath: indexPath,
                                                  cellType: LoadMoreCell.self)
            cell.spinnerView.startAnimating()
            return cell
        case .empty(let message):
            let cell = collectionView.dequeueCell(indexPath: indexPath,
                                                  cellType: EmptyCell.self)
            cell.messageLabel.text = message
            return cell
        }
    }
    
    private
    func configure(_ cell: MediaCell, model: Media, indexPath: IndexPath) {
        // Layout cell to get correct cell and image size
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        let url = mediaImageHelper.imageUrl(for: cell.mediaImageView.frame.size, media: model)

        cell.mediaImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.mediaImageView.sd_setImage(with: url, completed: nil)
        
        cell.gradientImageView.image = mediaImageHelper.gardientImage()
        
        cell.nameLabel.text = model.name
        
        // TODO: Check users units type (current: cm, kg)
        cell.heightLabel.isHidden = false
        if let height = model.appearance?.height?.last {
            cell.heightLabel.text = "\(Constants.height): \(height)"
        } else {
            cell.heightLabel.isHidden = true
        }
        
        cell.weightLabel.isHidden = false
        if let weight = model.appearance?.weight?.last {
            cell.weightLabel.text = "\(Constants.weight): \(weight)"
        } else {
            cell.weightLabel.isHidden = true
        }
    }
}

extension SuperHeroViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        checkNextPage(for: indexPath)
    }
}

extension SuperHeroViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var availableWidth = collectionView.bounds.size.width
        let insetForSection = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let minimumInteritemSpacingForSection = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
            
        switch collectionDataProvider.sections[indexPath.section] {
        case .items(_):
            availableWidth -= insetForSection.right + insetForSection.left
            availableWidth -= minimumInteritemSpacingForSection * CGFloat((Constants.numberOfColums - 1))
            let mediaWidth = availableWidth / CGFloat(Constants.numberOfColums)
            let mediaHeight = mediaWidth * CGFloat(Constants.imageAspectRatio)
            return CGSize(width: mediaWidth,
                          height: mediaHeight)
        case .loadMore:
            return CGSize(width: availableWidth,
                          height: CGFloat(Constants.loadMoreCellHeight))
        case .empty:
            return CGSize(width: availableWidth,
                          height: collectionView.bounds.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionDataProvider.sections[section] {
        case .items(_):
            return CGFloat(Constants.minimumLineSpacing)
        case .loadMore:
            return 0
        case .empty:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionDataProvider.sections[section] {
        case .items(_):
            return CGFloat(Constants.minimumInteritemSpacing)
        case .loadMore:
            return 0
        case .empty:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionDataProvider.sections[section] {
        case .items(_):
            return Constants.insetForMediaSection
        case .loadMore:
            return .zero
        case .empty:
            return .zero
        }
    }
}
