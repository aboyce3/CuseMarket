//
//  BuyingViewController.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 5/3/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class BuyingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct ProductSimple {
        var title: String
        var price: String
        var coverPhoto: UIImage
    }
    
    var db = Database.database().reference()
    var currentUID = Auth.auth().currentUser!.uid
    @IBOutlet weak var buyingTableView: UITableView!
    var results: [ProductSimple] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buyingTableView.delegate = self
        buyingTableView.dataSource = self
        getBuyingProduct()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuyingCell", for: indexPath) as! BuyingTableViewCell
        let item = results[indexPath.row]
        cell.setup(title: item.title, price: item.price, coverPhoto: item.coverPhoto)
        cell.backgroundColor = .orange
        return cell
    }
    
    func getBuyingProduct() {
        var productSimple = ProductSimple(title: "", price: "", coverPhoto: UIImage(systemName: "camera")!)
        db.child("Users").child(currentUID).child("Purchased").observe(.value){ snapshot in
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
                self.buyingTableView.reloadData()
            }
        }
    }
}
