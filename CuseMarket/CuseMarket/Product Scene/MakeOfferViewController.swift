//
//  MakeOfferViewController.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 5/2/22.
//

import UIKit
import FirebaseDatabase
import SwiftUI
import AVFoundation
import FirebaseAuth

class MakeOfferViewController: UIViewController {
    
    @IBOutlet weak var offerTextField: UITextField!
    @IBOutlet weak var listPriceLabel: UILabel!
    
    var productid: String?
    var productUserID: String?
    let offerUserID = Auth.auth().currentUser?.uid
    var offerUsername: String?
    let db = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        getInfoOffer()
    }
    
    func getInfoOffer() {
        db.child("Products").child(productid!).observeSingleEvent(of: .value) { snapshot in
            guard let snap = snapshot.value as? [String: Any] else { return }
            let price = snap["price"] as! String
            self.listPriceLabel.text = "Listing price: $ " + price
            self.productUserID = snap["userID"] as? String
        }
        
        db.child("Users").child(offerUserID!).observeSingleEvent(of: .value) { snapshot in
            guard let snap = snapshot.value as? [String: Any] else { return }
            self.offerUsername = snap["username"] as? String
        }
    }
    
    @IBAction func didTapOffer(_ sender: Any) {
        db.child("Users").child(productUserID!).child("Messages").setValue([
            "type": "Offer",
            "offerPrice": String(offerTextField.text!),
            "offerUsername": offerUsername!
        ])
        let alert = UIAlertController(title: "Congrats", message: "Offer sent!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
