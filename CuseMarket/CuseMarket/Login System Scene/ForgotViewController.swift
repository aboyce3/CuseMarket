//
//  ForgotViewController.swift
//  CuseMarket
//
//  Created by Andrew Boyce on 5/2/22.
//

import UIKit
import FirebaseAuth

class ForgotViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func recoverOnClick(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: email!.text!) { (error) in
            if (error as NSError?) != nil {
                let dialogMessage = UIAlertController(title: "Confirm", message: "Check your email and try again!", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                 })
                
                dialogMessage.addAction(ok)
                self.present(dialogMessage, animated: true, completion: nil)
            
          } else {
              let dialogMessage = UIAlertController(title: "Confirm", message: "A password reset email has been sent!", preferredStyle: .alert)
              
              let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                  print("Ok button tapped")
               })
              
              dialogMessage.addAction(ok)
              self.present(dialogMessage, animated: true, completion: nil)
              self.performSegue(withIdentifier: "loginReturnSegue", sender: self)
          }
        }
    }
    
    
}
