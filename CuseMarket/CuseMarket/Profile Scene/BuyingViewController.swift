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
    let p1 = ProductSimple(title: "AirPods", price: "99", coverPhoto: UIImage(systemName: "camera")!)
    let p2 = ProductSimple(title: "Vacuum", price: "100", coverPhoto: UIImage(systemName: "person")!)
    let p3 = ProductSimple(title: "White pants", price: "150", coverPhoto: UIImage(systemName: "cloud")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buyingTableView.delegate = self
        buyingTableView.dataSource = self
        results.append(p1)
        results.append(p2)
        results.append(p3)
        //getBuyingProduct()
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
        db.child("Users").child(currentUID).child("Purchased").observeSingleEvent(of: .value) { snapshot in
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
                self.buyingTableView.reloadData()
                //}
            }
        }
    }
}
