//
//  ScaledVisibleCellsCollectionView.swift
//  ScaledVisibleCellsCollectionView
//
//  Created by Mai Ikeda on 2015/08/22.
//  Copyright (c) 2015年 mai_ikeda. All rights reserved.
//

import UIKit

public enum SC_ScaledPattern {
    case horizontalCenter
    case horizontalLeft
    case horizontalRight
    case verticalCenter
    case verticalBottom
    case verticalTop
}

open class ScaledVisibleCellsCollectionView {
    static let sharedInstance = ScaledVisibleCellsCollectionView()
    
    var maxScale: CGFloat = 1.0
    var minScale: CGFloat = 0.5
    
    var maxAlpha: CGFloat = 1.0
    var minAlpha: CGFloat = 0.5
    
    var scaledPattern: SC_ScaledPattern = .verticalCenter
}

extension UICollectionView {
    
    /**
    Please always set
    */
    public func setScaledDesginParam(scaledPattern pattern: SC_ScaledPattern, maxScale: CGFloat, minScale: CGFloat, maxAlpha: CGFloat, minAlpha: CGFloat) {
        ScaledVisibleCellsCollectionView.sharedInstance.scaledPattern = pattern
        ScaledVisibleCellsCollectionView.sharedInstance.maxScale = maxScale
        ScaledVisibleCellsCollectionView.sharedInstance.minScale = minScale
        ScaledVisibleCellsCollectionView.sharedInstance.maxAlpha = maxAlpha
        ScaledVisibleCellsCollectionView.sharedInstance.minAlpha = minAlpha
    }
    
    /**
    Please call at any time
    */
    public func scaledVisibleCells() {
        switch ScaledVisibleCellsCollectionView.sharedInstance.scaledPattern {
        case .horizontalCenter, .horizontalLeft, .horizontalRight:
            scaleCellsForHorizontalScroll(visibleCells)
            break
        case .verticalCenter, .verticalTop, .verticalBottom:
            self.scaleCellsForVerticalScroll(visibleCells)
            break
        }
    }
}

extension UICollectionView {
    
    fileprivate func scaleCellsForHorizontalScroll(_ visibleCells: [UICollectionViewCell]) {
        
        let scalingAreaWidth = bounds.width / 2
        let maximumScalingAreaWidth = (bounds.width / 2 - scalingAreaWidth) / 2
        
        for cell in visibleCells  {
            var distanceFromMainPosition: CGFloat = 0
            
            switch ScaledVisibleCellsCollectionView.sharedInstance.scaledPattern {
            case .horizontalCenter:
                distanceFromMainPosition = horizontalCenter(cell)
                break
            case .horizontalLeft:
                distanceFromMainPosition = abs(cell.frame.midX - contentOffset.x - (cell.bounds.width / 2))
                break
            case .horizontalRight:
                distanceFromMainPosition = abs(bounds.width / 2 - (cell.frame.midX - contentOffset.x) + (cell.bounds.width / 2))
                break
            default:
                return
            }
            let preferredAry = scaleCells(distanceFromMainPosition, maximumScalingArea: maximumScalingAreaWidth, scalingArea: scalingAreaWidth)
            let preferredScale = preferredAry[0]
            let preferredAlpha = preferredAry[1]
            cell.transform = CGAffineTransform(scaleX: preferredScale, y: preferredScale)
            cell.alpha = preferredAlpha
        }
    }
    
    fileprivate func scaleCellsForVerticalScroll(_ visibleCells: [UICollectionViewCell]) {
        
        let scalingAreaHeight = bounds.height / 2
        let maximumScalingAreaHeight = (bounds.height / 2 - scalingAreaHeight) / 2
        
        for cell in visibleCells {
            var distanceFromMainPosition: CGFloat = 0
            
            switch ScaledVisibleCellsCollectionView.sharedInstance.scaledPattern {
            case .verticalCenter:
                distanceFromMainPosition = verticalCenter(cell)
                break
            case .verticalBottom:
                distanceFromMainPosition = abs(bounds.height - (cell.frame.midY - contentOffset.y + (cell.bounds.height / 2)))
                break
            case .verticalTop:
                distanceFromMainPosition = abs(cell.frame.midY - contentOffset.y - (cell.bounds.height / 2))
                break
            default:
                return
            }
            let preferredAry = scaleCells(distanceFromMainPosition, maximumScalingArea: maximumScalingAreaHeight, scalingArea: scalingAreaHeight)
            let preferredScale = preferredAry[0]
            let preferredAlpha = preferredAry[1]
            
            cell.transform = CGAffineTransform(scaleX: preferredScale, y: preferredScale)
            cell.alpha = preferredAlpha
        }
    }
    
    fileprivate func scaleCells(_ distanceFromMainPosition: CGFloat, maximumScalingArea: CGFloat, scalingArea: CGFloat) -> [CGFloat] {
        var preferredScale: CGFloat = 0.0
        var preferredAlpha: CGFloat = 0.0
        
        let maxScale = ScaledVisibleCellsCollectionView.sharedInstance.maxScale
        let minScale = ScaledVisibleCellsCollectionView.sharedInstance.minScale
        let maxAlpha = ScaledVisibleCellsCollectionView.sharedInstance.maxAlpha
        let minAlpha = ScaledVisibleCellsCollectionView.sharedInstance.minAlpha
        
        if distanceFromMainPosition < maximumScalingArea {
            // cell in maximum-scaling area
            preferredScale = maxScale
            preferredAlpha = maxAlpha
            
        } else if distanceFromMainPosition < (maximumScalingArea + scalingArea) {
            // cell in scaling area
            let multiplier = abs((distanceFromMainPosition - maximumScalingArea) / scalingArea)
            preferredScale = maxScale - multiplier * (maxScale - minScale)
            preferredAlpha = maxAlpha - multiplier * (maxAlpha - minAlpha)
            
        } else {
            // cell in minimum-scaling area
            preferredScale = minScale
            preferredAlpha = minAlpha
        }
        return [ preferredScale, preferredAlpha ]
    }
}

extension UICollectionView {
    
    fileprivate func horizontalCenter(_ cell: UICollectionViewCell)-> CGFloat {
        return abs(bounds.width / 2 - (cell.frame.midX - contentOffset.x))
    }
    
    fileprivate func verticalCenter(_ cell: UICollectionViewCell)-> CGFloat {
        return abs(bounds.height / 2 - (cell.frame.midY - contentOffset.y))
    }
}
