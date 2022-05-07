//
//  ProductViewController.swift
//  CuseMarket
//
//  Created by Andrew Boyce on 4/27/22.
//

import UIKit
import FirebaseDatabase

class ProductViewController: UIViewController {
    
    var productid: String?
    var accountid: String?
    var photos: [UIImage] = []
    var product: Product?
    let db = Database.database().reference()
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productCondition: UILabel!
    @IBOutlet weak var productLocation: UILabel!
    @IBOutlet weak var productDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        productCollectionView.collectionViewLayout = layout
        photos.append(UIImage(systemName: "camera")!)
//        let id = (productid ?? "no data") as String
//        print(id)
        getProductDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StorageManager.shared.getProductImages(productID: productid!) { results in
            self.photos = results!
            DispatchQueue.main.async {
                self.productCollectionView.reloadData()
            }
        }

    }
    
    func getProductDetails(){
        db.child("Products").child(productid!).observeSingleEvent(of: .value) { snapshot in
            guard let snap = snapshot.value as? [String: Any] else { return }
            self.productTitle.text = snap["title"] as? String
            self.productPrice.text = snap["price"] as? String
            self.productCondition.text = snap["condition"] as? String
            self.productDescription.text = snap["description"] as? String
            self.accountid = snap["userID"] as? String
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "offerSegue":
            let makeOfferViewController = segue.destination as! MakeOfferViewController
            makeOfferViewController.productid = productid
        case "messageSegue":
            let messageViewController = segue.destination as! MessageViewController
            messageViewController.productid = productid
        case "buySegue":
            let buyNowViewController = segue.destination as! BuyNowViewController
            buyNowViewController.productid = productid
            buyNowViewController.accountid = accountid
            buyNowViewController.productPrice = productPrice.text!
            buyNowViewController.productTitle = productTitle.text!
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}

extension ProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        cell.setup(with: photos[indexPath.row])
        return cell
    }
}

extension ProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
}
    
