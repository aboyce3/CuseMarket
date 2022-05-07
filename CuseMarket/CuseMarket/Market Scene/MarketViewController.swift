//
//  MarketViewController.swift
//  CuseMarket
//
//  Created by Andrew Boyce on 4/27/22.
//

import UIKit
import FirebaseDatabase
import SwiftUI

class MarketViewController: UIViewController {
    
    struct MarketProduct {
        var title: String
        var price: String
        var productID: String
        var coverPhoto: UIImage
    }

    var products: [MarketProduct] = []
    let db = Database.database().reference()

    @IBOutlet weak var marketCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marketCollectionView.dataSource = self
        marketCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        marketCollectionView.collectionViewLayout = layout
        getProducts()
    }
    
    
    func getProducts(){
        db.child("Products").observeSingleEvent(of: .value) { snapshot in
            guard let snapCollection = snapshot.value as? [String: Any] else { return }
            for snap in snapCollection {
                let dictionary = snap.value as? [String: Any]
                var product = MarketProduct(title: "", price: "", productID: "", coverPhoto: UIImage(systemName: "camera")!)
                product.title = dictionary!["title"] as! String
                product.price = dictionary!["price"] as! String
                product.productID = dictionary!["productID"] as! String
                StorageManager.shared.getProductImages(productID: product.productID) { results in
                    product.coverPhoto = (results?.first)!
                }
                self.products.append(product)
                DispatchQueue.main.async {
                    self.marketCollectionView.reloadData()
                }
            }

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showProduct"?:
            if let cell = sender as? UICollectionViewCell {
                if let indexPath = self.marketCollectionView.indexPath(for: cell) {
                    let id = products[indexPath.row].productID
                    print(id)
                    let productViewController = segue.destination as! ProductViewController
                    productViewController.productid = id
                }
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}

extension MarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketCollectionViewCell", for: indexPath) as! MarketCollectionViewCell
        let product = products[indexPath.row]
        cell.setup(with: product.coverPhoto, title: product.title, price: product.price)
        return cell
    }
}

extension MarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
}
