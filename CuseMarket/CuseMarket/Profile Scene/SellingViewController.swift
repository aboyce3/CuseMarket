//
//  SellingViewController.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 5/3/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SellingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref = Database.database().reference()
    var currentUID = Auth.auth().currentUser!.uid
    @IBOutlet weak var sellingTableView: UITableView!
    var results: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sellingTableView.delegate = self
        sellingTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellingCell", for: indexPath)
        return cell
    }
    
    func getSellingProduct() {
//        ref.child("Users").child(currentUID).child("Selling").observe(DataEventType.value) { snapshot in
//            self.results = []
//            guard let snapChildren = snapshot.value as? [String: Any] else { return
//            }
//        }
    }
    

}
