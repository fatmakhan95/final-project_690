//
//  SnapsTableViewController.swift
//  Snapchat
//
//  Created by Fatma Khan on 5/16/19.
//  Copyright © 2019 sadiw wafi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class SnapsTableViewController: UITableViewController {
   var snaps : [FIRDataSnapshot] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentUserUid = FIRAuth.auth()?.currentUser?.uid {
            FIRDatabase.database().reference().child("users").child(currentUserUid).child("snaps").observe(.childAdded, with: { (snapshot) in
                self.snaps.append(snapshot)
                self.tableView.reloadData()
                
                FIRDatabase.database().reference().child("users").child(currentUserUid).child("snaps").observe(.childRemoved, with: { (snapshot) in
                    
                    var index = 0
                    for snap in self.snaps {
                        if snapshot.key == snap.key {
                            self.snaps.remove(at: index)
                        }
                        index += 1
                    }
                    self.tableView.reloadData()
                })
            })
        }
       
    }

    // MARK: - Table view data source
    
    
    @IBAction func logoutTapped(_ sender: Any) {
       try? FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0 {
            return 1
        } else {
            return snaps.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if snaps.count == 0 {
            cell.textLabel?.text = "You have no snaps 😔"
        } else {
            let snap = snaps[indexPath.row]
            
            if let snapDictionary = snap.value as? NSDictionary {
                if let fromEmail = snapDictionary["from"] as? String {
                    cell.textLabel?.text = fromEmail
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let snap = snaps[indexPath.row]
        
        performSegue(withIdentifier: "viewSnapSugue", sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSnapSugue" {
            if let viewVC = segue.destination as? ViewTheSnapsViewController {
                
                if let snap = sender as? FIRDataSnapshot {
                    
                    viewVC.snap = snap
                }
            }
        }
    }
    
    
}
