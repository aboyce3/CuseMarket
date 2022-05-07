//
//  InboxViewController.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 5/3/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct Message{
        let message: String
        let username: String
        let type: String
    }
    let ref = Database.database().reference()
    let currentUID = Auth.auth().currentUser!.uid
    var results: [Message] = []
    @IBOutlet weak var inboxTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inboxTableView.delegate = self
        inboxTableView.dataSource = self
        getMessages()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return 1
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxCell", for: indexPath) as! InboxTableViewCell
        let item = results[indexPath.row]
        let text = item.username + ": " + item.message
        cell.setup(type: item.type, message: text)
        cell.setup(type: "Offer", message: "Hello from ZC")
        cell.backgroundColor = UIColor.systemTeal
        cell.textLabel?.text = item.type
        cell.textLabel?.text = text
        cell.backgroundColor = .orange
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
    func getMessages(){
        ref.child("Users").child(currentUID).child("Messages").observe(DataEventType.value) { snapshot in
            self.results = []
            guard let snapChildren = snapshot.value as? [String: Any]
            else { return }
                for snap in snapChildren {
                    let dictionary = snap.value as? [String: Any]
                    let username = dictionary!["username"]
                    let message = dictionary!["message"]
                    let type = dictionary!["type"]
                    let completeReview = Message(message: message as! String, username: username as! String, type: type as! String)
                    self.results.insert(completeReview, at: 0)
                    
          }
            self.inboxTableView.reloadData()
            
        }
    }
}
