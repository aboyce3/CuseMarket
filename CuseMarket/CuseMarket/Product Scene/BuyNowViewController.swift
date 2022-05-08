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
    var accountid: String?
    let db = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
                self.db.child("Users").child(self.accountid!).child("Sellings").child(self.productid!).removeValue()
                var counter = 0
                self.db.child("Users").child(self.accountid!).child("Messages").observe(.value, with: { (snapshot: DataSnapshot!) in
                    counter = Int(snapshot.childrenCount) + 1
                })
                self.db.child("Users").child(Auth.auth().currentUser!.uid).getData(completion:  { error, snapshot in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return;
                    }
                
                    guard let dictionary = snapshot.value as? [String : Any] else {return}
                    let username = dictionary["username"] as! String
                    print(username)
                    let m = self.productTitle! + " has sold!"
                    self.db.child("Users").child(self.accountid!).child("Messages").child(String(counter)).setValue(["message": m, "type" : "Purchase", "username" : username])
                    self.db.child("Users").child(Auth.auth().currentUser!.uid).child("Purchased").child(self.productid!).setValue(["title": self.productTitle!, "price" : self.productPrice!])
                    self.performSegue(withIdentifier: "returnHomeSegue", sender: self)
                });
            })

            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }

    @IBAction func paypalOnClick(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Purchase successful!", preferredStyle: .alert)

        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.db.child("Products").child(self.productid!).removeValue()
            self.db.child("Users").child(self.accountid!).child("Sellings").child(self.productid!).removeValue()
            var counter = 0
            self.db.child("Users").child(self.accountid!).child("Messages").observe(.value, with: { (snapshot: DataSnapshot!) in
                counter = Int(snapshot.childrenCount) + 1
            })
            self.db.child("Users").child(Auth.auth().currentUser!.uid).getData(completion:  { error, snapshot in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return;
                }
            
                guard let dictionary = snapshot.value as? [String : Any] else {return}
                let username = dictionary["username"] as! String
                print(username)
                let m = self.productTitle! + " has sold!"
                self.db.child("Users").child(self.accountid!).child("Messages").child(String(counter)).setValue(["message": m, "type" : "Purchase", "username" : username])
                self.db.child("Users").child(Auth.auth().currentUser!.uid).child("Purchased").child(self.productid!).setValue(["title": self.productTitle!, "price" : self.productPrice!])
                self.performSegue(withIdentifier: "returnHomeSegue", sender: self)
            });
        })

        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }

    @IBAction func venmoOnClick(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Purchase successful!", preferredStyle: .alert)

        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.db.child("Products").child(self.productid!).removeValue()
            self.db.child("Users").child(self.accountid!).child("Sellings").child(self.productid!).removeValue()
            var counter = 0
            self.db.child("Users").child(self.accountid!).child("Messages").observe(.value, with: { (snapshot: DataSnapshot!) in
                counter = Int(snapshot.childrenCount) + 1
            })
            self.db.child("Users").child(Auth.auth().currentUser!.uid).getData(completion:  { error, snapshot in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return;
                }
            
                guard let dictionary = snapshot.value as? [String : Any] else {return}
                let username = dictionary["username"] as! String
                print(username)
                let m = self.productTitle! + " has sold!"
                self.db.child("Users").child(self.accountid!).child("Messages").child(String(counter)).setValue(["message": m, "type" : "Purchase", "username" : username])
                self.db.child("Users").child(Auth.auth().currentUser!.uid).child("Purchased").child(self.productid!).setValue(["title": self.productTitle!, "price" : self.productPrice!])
                self.performSegue(withIdentifier: "returnHomeSegue", sender: self)
            });
        })

        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }

}
