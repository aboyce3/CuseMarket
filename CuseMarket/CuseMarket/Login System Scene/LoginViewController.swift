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
            if error == nil{
                print("Made it in!")
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            } else{
                print("Didn't make it!")
            }
        }
       
    }
    
    @IBAction func createAccountOnClick(_ sender: Any) {
        performSegue(withIdentifier: "createAccountSegue", sender: self)
    }
}
