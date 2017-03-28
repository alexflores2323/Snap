//
//  SnapListViewController.swift
//  Snap
//
//  Created by Logan Caracci on 2/19/17.
//  Copyright © 2017 Logan Caracci. All rights reserved.
//

import UIKit
import Firebase

class SnapListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var snaps : [Snap] = []
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            print(snapshot)
            
            
            let value = snapshot.value as? NSDictionary
            let snap = Snap()
            
            snap.imageURL = value!["imageURL"] as! String
            snap.from = value!["from"] as! String
            snap.descrip = value!["description"] as! String
            snap.key = snapshot.key
            snap.uuid = value!["uuid"] as! String
            
            
            
            
            self.snaps.append(snap)
            self.tableView.reloadData()
        })
        
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").observe(FIRDataEventType.childRemoved, with: {(snapshot) in
            print(snapshot)
            
            var index = 0
            
            for snap in self.snaps {
                if snap.key == snapshot.key {
                    
                    self.snaps.remove(at: index)
                }
                
                index += 1
            }
            
            self.tableView.reloadData()
        })
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if snaps.count == 0 {
            return 1
        } else {
            return snaps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if snaps.count == 0 {
            cell.textLabel?.text = "You have no snaps loser 😢"
        } else {
            let snap = snaps[indexPath.row]
            cell.textLabel?.text = snap.from
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "viewsnapsegue", sender: snap)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewsnapsegue" {
            
            let nextVC = segue.destination as! ViewSnapViewController
            
            nextVC.snap = sender as! Snap
            
        }
    }
    
    
    
    
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
