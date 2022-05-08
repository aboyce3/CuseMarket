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
    var offerToUserID: String?
    let offerFromUserID = Auth.auth().currentUser?.uid
    var offerFromUsername: String?
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
            self.offerToUserID = snap["userID"] as? String
        }
        
        db.child("Users").child(offerFromUserID!).observeSingleEvent(of: .value) { snapshot in
            guard let snap = snapshot.value as? [String: Any] else { return }
            self.offerFromUsername = snap["username"] as? String
        }
    }
    
    @IBAction func didTapOffer(_ sender: Any) {
        let uuid = UUID().uuidString
        db.child("Users").child(offerToUserID!).child("Messages").child(uuid).setValue([
            "type": "Offer",
            "message": String(offerTextField.text!),
            "username": offerFromUsername!
        ])
        let alert = UIAlertController(title: "Congrats", message: "Offer sent!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "returnHomeSegue", sender: self)
            return
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
