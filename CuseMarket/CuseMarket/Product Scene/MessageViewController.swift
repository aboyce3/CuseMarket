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
    var sendToUserID: String?
    let sendFromUserID = Auth.auth().currentUser?.uid
    var sendFromUsername: String?
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
            self.sendToUserID = snap["userID"] as? String
            
            self.db.child("Users").child(self.sendToUserID!).observeSingleEvent(of: .value) { snapshot in
                guard let snap = snapshot.value as? [String: Any] else { return }
                self.usernameLabel.text = snap["username"] as? String
            }
        }
        
        db.child("Users").child(sendFromUserID!).observeSingleEvent(of: .value) { snapshot in
            guard let snap = snapshot.value as? [String: Any] else { return }
            self.sendFromUsername = snap["username"] as? String
        }
        
        StorageManager.shared.getProductFirstImage(productID: productid!) { result in
            self.imageView.image = result
        }
    }
    

    @IBAction func didTapSend(_ sender: Any) {
        let uuid = UUID().uuidString
        db.child("Users").child(sendToUserID!).child("Messages").child(uuid).setValue([
            "type": "Text",
            "message": String(textTextField.text!),
            "username": sendFromUsername
        ])
        let alert = UIAlertController(title: "Congrats", message: "Text sent!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "returnHomeSegue", sender: self)
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

}
