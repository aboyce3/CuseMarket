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

    var ref = Database.database().reference()
    var currentUID = Auth.auth().currentUser!.uid
    @IBOutlet weak var tableView: UITableView!
    var results: [Message]?
    
    struct Message{
        let message:String?
        let username:String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getMessages()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let text = results![indexPath.item].username! + ": " + results![indexPath.item].message!
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.systemTeal
        cell.textLabel?.text = text
        cell.backgroundColor = .orange
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
    func getMessages(){
        ref.child("Users").child(currentUID).child("Messages").observe(DataEventType.value) { snapshot in
            self.results = []
            guard let snapChildren = snapshot.value as? [String: Any] else { return }
                for snap in snapChildren {
                    let dictionary = snap.value as? [String: Any]
                    let username = dictionary!["Username"]
                    let message = dictionary!["Message"]
                    let completeMessage = Message(message: (message as! String), username: (username as! String))
                    self.results?.append(completeMessage)
                    print(completeMessage.message!)
          }
            self.tableView.reloadData()
            
        }
    }
    
}
