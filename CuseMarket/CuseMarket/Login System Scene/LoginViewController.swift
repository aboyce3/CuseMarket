//
//  LoginViewController.swift
//  CuseMarket
//
//  Created by Andrew Boyce on 4/27/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginOnClick(_ sender: Any) {
        Auth.auth().signIn(withEmail: (email.text ?? "None"), password: password.text ?? "Nothing") { (result, error) in
            if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified {
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                } else {
                    let dialogMessage = UIAlertController(title: "Confirm", message: "You are either unverified or have incorrect credentials!", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        print("Ok button tapped")
                     })
                    
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
            }
        }
       
    }

}
