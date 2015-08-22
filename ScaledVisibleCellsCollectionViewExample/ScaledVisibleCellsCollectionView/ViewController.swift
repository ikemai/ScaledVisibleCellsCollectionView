//
//  ViewController.swift
//  ScaledVisibleCellsCollectionView
//
//  Created by ikemai on 08/22/2015.
//  Copyright (c) 2015 ikemai. All rights reserved.
//

import UIKit
import ScaledVisibleCellsCollectionView

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: ScaledVisibleCellsCollectionView!
    private let cellIdentifier = "CollectionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Example: set 'VerticalCenter'
        collectionView.setScaledDesginParam(scaledPattern: .VerticalCenter, maxScale: 1.2, minScale: 0.5, maxAlpha: 1.0, minAlpha: 0.5)
        // Example: set 'VerticalTop'
//        collectionView.setScaledDesginParam(scaledPattern: .VerticalTop, maxScale: 1.2, minScale: 0.5, maxAlpha: 1.0, minAlpha: 0.5)
        // Example: set 'VerticalBottom'
//        collectionView.setScaledDesginParam(scaledPattern: .VerticalBottom, maxScale: 1.2, minScale: 0.5, maxAlpha: 1.0, minAlpha: 0.5)
        // Example: set 'HorizontalCenter'
//        collectionView.setScaledDesginParam(scaledPattern: .HorizontalCenter, maxScale: 1.2, minScale: 0.5, maxAlpha: 1.0, minAlpha: 0.5)
        // Example: set 'HorizontalLeft'
//        collectionView.setScaledDesginParam(scaledPattern: .HorizontalLeft, maxScale: 1.2, minScale: 0.5, maxAlpha: 1.0, minAlpha: 0.5)
        // Example: set 'HorizontalRight'
//        collectionView.setScaledDesginParam(scaledPattern: .HorizontalRight, maxScale: 1.2, minScale: 0.5, maxAlpha: 1.0, minAlpha: 0.5)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
//
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: AnyObject = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        return cell as! UICollectionViewCell
    }
}


//
// MARK: - UIScrollViewDelegate
//
extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        collectionView.scaledVisibleCells()
    }
}