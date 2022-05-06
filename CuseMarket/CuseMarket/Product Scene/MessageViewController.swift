//
//  MassageViewController.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 5/2/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MessageViewController: UIViewController {
    
    var productid: String?
    var productUserID: String?
    let sendUserID = Auth.auth().currentUser?.uid
    var sendUsername: String?
    let db = Database.database().reference()

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var textTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfoMessage()
    }
    
    func getInfoMessage() {
        db.child("Products").child(productid!).observeSingleEvent(of: .value) { snapshot in
            guard let snap = snapshot.value as? [String: Any] else { return }
            self.productTitleLabel.text = snap["title"] as? String
            self.productUserID = snap["userID"] as? String
        }
        
        db.child("Users").child(productUserID!).observeSingleEvent(of: .value) { snapshot in
            guard let snap = snapshot.value as? [String: Any] else { return }
            self.usernameLabel.text = snap["username"] as? String
        }
        
        db.child("Users").child(sendUserID!).observeSingleEvent(of: .value) { snapshot in
            guard let snap = snapshot.value as? [String: Any] else { return }
            self.sendUsername = snap["username"] as? String
        }
        
    }
    

    @IBAction func didTapSend(_ sender: Any) {
        db.child("Users").child(productUserID!).child("Messages").setValue([
            "type": "Text",
            "textInfo": String(textTextField.text!),
            "offerUsername": sendUsername
        ])
        let alert = UIAlertController(title: "Congrats", message: "Text sent!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

}
