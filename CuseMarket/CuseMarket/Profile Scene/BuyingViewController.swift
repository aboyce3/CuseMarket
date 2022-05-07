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
    
    var ref = Database.database().reference()
    var currentUID = Auth.auth().currentUser!.uid
    @IBOutlet weak var buyingTableView: UITableView!
    var results: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buyingTableView.delegate = self
        buyingTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuyingCell", for: indexPath)
        return cell
    }
}
