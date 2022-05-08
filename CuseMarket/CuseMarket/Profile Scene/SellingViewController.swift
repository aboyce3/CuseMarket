//
//  SellingViewController.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 5/3/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftUI

class SellingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct ProductSimple {
        var title: String
        var price: String
        var coverPhoto: UIImage
    }
    
    var db = Database.database().reference()
    var currentUID = Auth.auth().currentUser!.uid
    var results: [ProductSimple] = []
    
    @IBOutlet weak var sellingTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        sellingTableView.delegate = self
        sellingTableView.dataSource = self
        getSellingProduct()
    }
    
    func getSellingProduct() {
        var productSimple = ProductSimple(title: "", price: "", coverPhoto: UIImage(systemName: "camera")!)
        db.child("Users").child(currentUID).child("Sellings").observe(.value) { snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                guard let dictionary = snap.value as? [String: Any] else {return}
                let productid = snap.key
                StorageManager.shared.getProductFirstImage(productID: productid) { image in
                    productSimple.coverPhoto = image!
                }
                print(dictionary)
                let productTitle = dictionary["title"] as! String
                productSimple.title = productTitle
                let productPrice = dictionary["price"] as! String
                productSimple.price = productPrice
                self.results.append(productSimple)
                self.sellingTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("results: " + String(results.count))
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellingCell", for: indexPath) as! SellingTableViewCell
        let item = results[indexPath.row]
        cell.setup(title: item.title, price: item.price, coverPhoto: item.coverPhoto)
        cell.backgroundColor = .orange
        return cell
    }
}
