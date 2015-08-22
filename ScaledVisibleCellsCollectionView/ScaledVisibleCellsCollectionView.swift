//
//  ScaledVisibleCellsCollectionView.swift
//  ScaledVisibleCellsCollectionView
//
//  Created by Mai Ikeda on 2015/08/22.
//  Copyright (c) 2015年 mai_ikeda. All rights reserved.
//

import UIKit

public enum SC_ScaledPattern {
    case HorizontalCenter
    case HorizontalLeft
    case HorizontalRight
    case VerticalCenter
    case VerticalBottom
    case VerticalTop
}

public class ScaledVisibleCellsCollectionView: UICollectionView {
    private var maxScale: CGFloat = 1.0
    private var minScale: CGFloat = 0.5
    
    private var maxAlpha: CGFloat = 1.0
    private var minAlpha: CGFloat = 0.5
    
    private var scaledPattern: SC_ScaledPattern = .VerticalCenter
    
    /**
    Please always set
    */
    public func setScaledDesginParam(scaledPattern pattern: SC_ScaledPattern, maxScale: CGFloat, minScale: CGFloat, maxAlpha: CGFloat, minAlpha: CGFloat) {
        scaledPattern = pattern
        self.maxScale = maxScale
        self.minScale = minScale
        self.maxAlpha = maxAlpha
        self.minAlpha = minAlpha
    }
    
    /**
    Please call at any time
    */
    public func scaledVisibleCells() {
        switch scaledPattern {
        case .HorizontalCenter, .HorizontalLeft, .HorizontalRight:
            scaleCellsForHorizontalScroll(visibleCells() as! [UICollectionViewCell])
            break
        case .VerticalCenter, .VerticalTop, .VerticalBottom:
            self.scaleCellsForVerticalScroll(visibleCells() as! [UICollectionViewCell])
            break
        }
    }
}

extension ScaledVisibleCellsCollectionView {
    
    private func scaleCellsForHorizontalScroll(visibleCells: [UICollectionViewCell]) {
        
        let scalingAreaWidth = bounds.width / 2
        let maximumScalingAreaWidth = (bounds.width / 2 - scalingAreaWidth) / 2
        
        for cell in visibleCells  {
            var distanceFromMainPosition: CGFloat = 0
            
            switch scaledPattern {
            case .HorizontalCenter:
                distanceFromMainPosition = horizontalCenter(cell)
                break
            case .HorizontalLeft:
                distanceFromMainPosition = abs(cell.frame.midX - contentOffset.x - (cell.bounds.width / 2))
                break
            case .HorizontalRight:
                distanceFromMainPosition = abs(bounds.width / 2 - (cell.frame.midX - contentOffset.x) + (cell.bounds.width / 2))
                break
            default:
                return
            }
            let preferredAry = scaleCells(distanceFromMainPosition, maximumScalingArea: maximumScalingAreaWidth, scalingArea: scalingAreaWidth)
            let preferredScale = preferredAry[0]
            let preferredAlpha = preferredAry[1]
            cell.transform = CGAffineTransformMakeScale(preferredScale, preferredScale)
            cell.alpha = preferredAlpha
        }
    }
    
    private func scaleCellsForVerticalScroll(visibleCells: [UICollectionViewCell]) {
        
        let scalingAreaHeight = bounds.height / 2
        let maximumScalingAreaHeight = (bounds.height / 2 - scalingAreaHeight) / 2
        
        for cell in visibleCells {
            var distanceFromMainPosition: CGFloat = 0
            
            switch scaledPattern {
            case .VerticalCenter:
                distanceFromMainPosition = verticalCenter(cell)
                break
            case .VerticalBottom:
                distanceFromMainPosition = abs(bounds.height - (cell.frame.midY - contentOffset.y + (cell.bounds.height / 2)))
                break
            case .VerticalTop:
                distanceFromMainPosition = abs(cell.frame.midY - contentOffset.y - (cell.bounds.height / 2))
                break
            default:
                return
            }
            let preferredAry = scaleCells(distanceFromMainPosition, maximumScalingArea: maximumScalingAreaHeight, scalingArea: scalingAreaHeight)
            let preferredScale = preferredAry[0]
            let preferredAlpha = preferredAry[1]
            
            cell.transform = CGAffineTransformMakeScale(preferredScale, preferredScale)
            cell.alpha = preferredAlpha
        }
    }
    
    private func scaleCells(distanceFromMainPosition: CGFloat, maximumScalingArea: CGFloat, scalingArea: CGFloat) -> [CGFloat] {
        var preferredScale: CGFloat = 0.0
        var preferredAlpha: CGFloat = 0.0
        
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

extension ScaledVisibleCellsCollectionView {
    
    private func horizontalCenter(cell: UICollectionViewCell)-> CGFloat {
        return abs(bounds.width / 2 - (cell.frame.midX - contentOffset.x))
    }
    
    private func verticalCenter(cell: UICollectionViewCell)-> CGFloat {
        return abs(bounds.height / 2 - (cell.frame.midY - contentOffset.y))
    }
}