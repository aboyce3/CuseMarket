//
//  BuyNowViewController.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 5/2/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class BuyNowViewController: UIViewController {

    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var address1: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var monthYear: UITextField!
    @IBOutlet weak var securityCode: UITextField!

    var productid: String?
    var productTitle: String?
    var productPrice: String?
    var sellerUserID: String?
    var buyerUsername: String?
    let buyerUserID = Auth.auth().currentUser!.uid
    let db = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        // get current user's username
        db.child("Users").child(buyerUserID).getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            self.buyerUsername = dictionary["username"] as? String
            print(self.buyerUsername ?? "Default Username")
        });
    }
    

    @IBAction func buyNowOnClick(_ sender: Any) {
        if(fullName.text! == "" || address1.text == "" || city.text! == "" || zipCode.text! == "" || state.text! == "" || phoneNumber.text! == "" || email.text! == "" || cardNumber.text! == "" || monthYear.text! == "" || securityCode.text! == "" || phoneNumber.text!.count != 10 || !email.text!.contains("@syr.edu") || state.text!.count != 2){
            
            let dialogMessage = UIAlertController(title: "Confirm", message: "Please verify your information and try again!", preferredStyle: .alert)

            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                return
            })

            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)

        } else {
            let dialogMessage = UIAlertController(title: "Confirm", message: "Purchase successful!", preferredStyle: .alert)

            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                self.db.child("Products").child(self.productid!).removeValue()
                self.db.child("Users").child(self.sellerUserID!).child("Sellings").child(self.productid!).removeValue()
                let message = self.productTitle! + " has sold!"
                let uuid = UUID().uuidString
                self.db.child("Users").child(self.sellerUserID!).child("Messages").child(uuid).setValue(["message": message, "type" : "Purchased", "username" : self.buyerUsername])
                self.db.child("Users").child(Auth.auth().currentUser!.uid).child("Purchased").child(self.productid!).setValue(["title": self.productTitle!, "price" : self.productPrice!])
                self.performSegue(withIdentifier: "returnHomeSegue", sender: self)
            })

            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }

    @IBAction func paypalOnClick(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Purchase successful!", preferredStyle: .alert)

        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.db.child("Products").child(self.productid!).removeValue()
            self.db.child("Users").child(self.sellerUserID!).child("Sellings").child(self.productid!).removeValue()
            let message = self.productTitle! + " has sold!"
            let uuid = UUID().uuidString
            self.db.child("Users").child(self.sellerUserID!).child("Messages").child(uuid).setValue(["message": message, "type" : "Purchased", "username" : self.buyerUsername])
            self.db.child("Users").child(Auth.auth().currentUser!.uid).child("Purchased").child(self.productid!).setValue(["title": self.productTitle!, "price" : self.productPrice!])
            self.performSegue(withIdentifier: "returnHomeSegue", sender: self)
        })

        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }

    @IBAction func venmoOnClick(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Purchase successful!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.db.child("Products").child(self.productid!).removeValue()
            self.db.child("Users").child(self.sellerUserID!).child("Sellings").child(self.productid!).removeValue()
            let message = self.productTitle! + " has sold!"
            let uuid = UUID().uuidString
            self.db.child("Users").child(self.sellerUserID!).child("Messages").child(uuid).setValue(["message": message, "type" : "Purchased", "username" : self.buyerUsername])
            self.db.child("Users").child(Auth.auth().currentUser!.uid).child("Purchased").child(self.productid!).setValue(["title": self.productTitle!, "price" : self.productPrice!])
            self.performSegue(withIdentifier: "returnHomeSegue", sender: self)
        })
        
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
