//
//  BuyNowViewController.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 5/2/22.
//

import UIKit
import SafariServices
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buyNowOnClick(_ sender: Any) {
        if(fullName.text! == "" || address1.text == "" || city.text! == "" || zipCode.text! == "" || state.text! == "" || phoneNumber.text! == "" || email.text! == "" ||
           cardNumber.text! == "" || monthYear.text! == "" || securityCode.text! == ""){
            let dialogMessage = UIAlertController(title: "Confirm", message: "Please verify your information and try again!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                return
             })
            
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        } else {
            let dialogMessage = UIAlertController(title: "Confirm", message: "Purchase successful!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                self.performSegue(withIdentifier: "returnSegue", sender: self)
             })
            
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    @IBAction func paypalOnClick(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Purchase successful!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "returnSegue", sender: self)
         })
        
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBAction func venmoOnClick(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Purchase successful!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "returnSegue", sender: self)
         })
        
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}

