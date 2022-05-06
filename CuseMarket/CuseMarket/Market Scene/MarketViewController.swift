//
//  MarketViewController.swift
//  CuseMarket
//
//  Created by Andrew Boyce on 4/27/22.
//

import UIKit

class MarketViewController: UIViewController {
    
    var products: [Product] = []

    @IBOutlet weak var marketCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marketCollectionView.dataSource = self
        marketCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        // layout.scrollDirection = .horizontal
        marketCollectionView.collectionViewLayout = layout
    }

}

extension MarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketCollectionViewCell", for: indexPath) as! MarketCollectionViewCell
        let product = products[indexPath.row]
        cell.setup(with: product.title, with: product.price)
        return cell
    }
}

extension MarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
}
