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
    let p1 = ProductSimple(title: "Winter Jacket", price: "20", coverPhoto: UIImage(systemName: "camera")!)
    let p2 = ProductSimple(title: "Dining Table", price: "100", coverPhoto: UIImage(systemName: "person")!)
    let p3 = ProductSimple(title: "Iphone XR", price: "150", coverPhoto: UIImage(systemName: "cloud")!)
    
    @IBOutlet weak var sellingTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        sellingTableView.delegate = self
        sellingTableView.dataSource = self
        // getSellingProduct()
        results.append(p1)
        results.append(p2)
        results.append(p3)
    }
    
    func getSellingProduct() {
        var productSimple = ProductSimple(title: "", price: "", coverPhoto: UIImage(systemName: "camera")!)
        db.child("Users").child(currentUID).child("Sellings").observeSingleEvent(of: .value) { snapshot in
            guard let productNos = snapshot.value as? [String: Any] else { return }
            for No in productNos {
                let productid = No.value as! String
                print("pid: " + productid)
                StorageManager.shared.getProductFirstImage(productID: productid) { image in
                    productSimple.coverPhoto = image!
                }
                self.db.child("Products").child(productid).observeSingleEvent(of: .value) { [self] snapshot in
                    guard let dic = snapshot.value as? [String: Any] else { return }
                    let productTitle = dic["title"] as! String
                    productSimple.title = productTitle
                    let productPrice = dic["price"] as! String
                    productSimple.price = productPrice
                }
                self.results.append(productSimple)
                //DispatchQueue.main.async {
                self.sellingTableView.reloadData()
                //}
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
