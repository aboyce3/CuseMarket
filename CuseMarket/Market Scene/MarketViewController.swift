//
//  MarketViewController.swift
//  CuseMarket
//
//  Created by Andrew Boyce on 4/27/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SwiftUI

class MarketViewController: UIViewController {
    
    struct MarketProduct {
        var title: String
        var price: String
        var productID: String
        var coverPhoto: UIImage
    }

    var products: [MarketProduct] = []
    var filteredProducts: [MarketProduct] = [] // for Search Bar, and pass these to collection view
    let db = Database.database().reference()

    @IBOutlet weak var marketCollectionView: UICollectionView!
    @IBOutlet weak var marketSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marketCollectionView.dataSource = self
        marketCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        marketCollectionView.collectionViewLayout = layout
        
        marketSearchBar.delegate = self
        getProducts()
    }
    
    
    func getProducts(){
        db.child("Products").observeSingleEvent(of: .value) { snapshot in
            guard let snapCollection = snapshot.value as? [String: Any] else { return }
            for snap in snapCollection {
                let dictionary = snap.value as? [String: Any]
                let title1 = dictionary!["title"] as! String
                let price1 = dictionary!["price"] as! String
                let productID1 = dictionary!["productID"] as! String
                var image1 = UIImage(systemName: "person")
                StorageManager.shared.getProductFirstImage(productID: productID1) { image in
                    image1 = image!
                    let product = MarketProduct(title: title1, price: price1, productID: productID1, coverPhoto: image1!)
                    let userIDTemp = dictionary!["userID"] as! String
                    if (userIDTemp != Auth.auth().currentUser!.uid) {
                        self.products.append(product)
                        self.filteredProducts.append(product)
                    }
                    self.marketCollectionView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        return filteredProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketCollectionViewCell", for: indexPath) as! MarketCollectionViewCell
        let product = filteredProducts[indexPath.row]
        cell.setup(with: product.coverPhoto, title: product.title, price: product.price)
        return cell
    }
}

extension MarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
}

// MARK: Search Bar Config
extension MarketViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredProducts = []
        if searchText == "" {
            filteredProducts = products
        }
        else {
            for product in products {
                if product.title.lowercased().contains(searchText.lowercased()) {
                    filteredProducts.append(product)
                }
            }
        }
        self.marketCollectionView.reloadData()
    }
}
