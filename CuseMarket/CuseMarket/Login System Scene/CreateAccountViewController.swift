//
//  CreateAccountViewController.swift
//  CuseMarket
//
//  Created by Andrew Boyce on 4/27/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var ref = Database.database().reference()
    
    private var authUser : User? {
        return Auth.auth().currentUser
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    public func sendVerificationMail() -> Bool {
        var completed = true
        if self.authUser != nil && !self.authUser!.isEmailVerified {
            self.authUser!.sendEmailVerification(completion: { (error) in
                completed = false
            })
        }
        else {
            return completed
        }
        return completed
    }

    public func userNotExist() -> Bool{
        var exists = true
        ref.child(username.text!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                exists = false
            }
        })
        return exists
    }
    
    @IBAction func registerOnClick(_ sender: Any) {
        if password.text != "" && passwordConfirm.text != "" && email.text != "" && username.text != ""{
            if password.text!.count >= 8 && password.text!.count <= 16 && password.text! == passwordConfirm.text! && email.text!.hasSuffix("@syr.edu") && userNotExist(){
                Auth.auth().createUser(withEmail: email.text!, password: password.text!) { [self] (result, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        errorLabel.text = "Check your email and/or password, try again!"
                        
                    } else {
                        if self.sendVerificationMail() {
                            self.ref.child("Users").child(Auth.auth().currentUser!.uid).setValue(["firstName" : firstName.text!, "lastName" : lastName.text!, "email" : self.email.text!, "username" : self.username.text!])
                            let dialogMessage = UIAlertController(title: "Confirm", message: "Once your email is verified you may sign in.", preferredStyle: .alert)
                            
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                self.performSegue(withIdentifier: "returnSegue", sender: self)
                             })
                            dialogMessage.addAction(ok)
                            self.present(dialogMessage, animated: true, completion: nil)
                            
                            return
                        } else {
                            errorLabel.text = "Email is already verified, try a different email!"
                        }
                    }
                }
            } else {
                errorLabel.text = "Check that you are using a syracuse email or your password could be out of constraint!!"
            }
        } else {
            errorLabel.text = "Something was left blank!"
        }
    }

}
