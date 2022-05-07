//
//  InboxViewController.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 5/3/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftUI

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    struct Message{
        let message: String
        let username: String
        let type: String
    }
    let m1 = Message(message: "20", username: "Joe", type: "Offer")
    let m2 = Message(message: "Bought it!", username: "Sam", type: "Purchased")
    let m3 = Message(message: "Is this availiable", username: "Alice", type: "Text")
    let db = Database.database().reference()
    let currentUID = Auth.auth().currentUser!.uid
    var results: [Message] = []

    @IBOutlet weak var inboxTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        inboxTableView.delegate = self
        inboxTableView.dataSource = self
        results.append(m1)
        results.append(m2)
        results.append(m3)
        // getMessages()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxCell", for: indexPath) as! InboxTableViewCell
        let item = results[indexPath.row]
        // let text = item.username + ": " + item.message
        cell.setup(type: item.type, message: item.message, username: item.username)
        // cell.setup(type: "Offer", message: "Hello from ZC")
        cell.backgroundColor = .orange
        cell.textLabel?.textColor = .white
        return cell
    }

    func getMessages () {
        db.child("Users").child(currentUID).child("Messages").getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let messNos = snapshot.value as? [String: Any] else {
                print("No data")
                return
            }
            for No in messNos {
                print(No)
                let dictionary = No.value as? [String: Any]
                let username = dictionary!["username"]
                let message = dictionary!["message"]
                let type = dictionary!["type"]
                let completeMessage = Message(message: message as! String, username: username as! String, type: type as! String)
                self.results.append(completeMessage)
            }
        }
    }

}
