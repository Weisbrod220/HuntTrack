//
//  SecondViewController.swift
//  HuntTrack
//
//  Created by Evan Weisbrod on 3/29/16.
//  Copyright © 2016 Evan Weisbrod. All rights reserved.
//

import UIKit
import QuartzCore
import Firebase

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let myRootRef = Firebase(url: "https://hunttracker.firebaseio.com/users/");
    
    
    @IBOutlet weak var partyMemberTable: UITableView!
    
    override func viewDidLoad() {
        
         //self.partyMemberTable.reloadData()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(animated: Bool)
    {
       super.viewWillAppear(true)
        self.partyMemberTable.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       if(nameSingleton.partymembers.count == 0)
       {
        return 1
        }
        else
       {
        return nameSingleton.partymembers.count
        }
    }
    
    @IBAction func addMember(sender: AnyObject)
    {
        let alert2 = UIAlertController(title: "Add Party Member",
            message: "Add Party Member",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Add",
            style: .Default)
            { (action: UIAlertAction) -> Void in
                 nameSingleton.addedmember = alert2.textFields![0].text
                //query if party member exists 
                
                self.myRootRef.observeEventType(.ChildAdded, withBlock:
                    {
                       
                        snapshot in

                
                        //print(snapshot.key)
                        var memberslist = [String]()
                        memberslist.append(snapshot.key)
                        for(var i = 0; i < memberslist.count; i++)
                        {
                          if(memberslist[i] == nameSingleton.addedmember)
                          {
                            nameSingleton.partymembers.append(nameSingleton.addedmember!)
                            self.partyMemberTable.reloadData()
                            }
                        }
                                    })
                let myparty = ["PartyMember" : "\(nameSingleton.partymembers)", "Lat" : "\(nameSingleton.memberlats)", "Long" : "\(nameSingleton.memberlongs)"]
                let myref = Firebase(url:"https://hunttracker.firebaseio.com/users/\(nameSingleton.currUsername!)/PartyMembers")
                // Write data to Firebase
                var partmemberref = myref.childByAppendingPath("Party")
                partmemberref.updateChildValues(myparty)
                self.getdata()
                
                
            }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert2.addTextFieldWithConfigurationHandler {
            (textName) -> Void in
            textName.placeholder = "Enter your Username"
        }
        
        alert2.addAction(saveAction)
        alert2.addAction(cancelAction)
        
        presentViewController(alert2,
            animated: true,
            completion: nil)
    }

    func getdata()
    {
        print("here")
       
            
                print(nameSingleton.addedmember!)
                //print("\(nameSingleton.partymembers[0])")
                
                 let longRef = Firebase(url: "https://hunttracker.firebaseio.com/users/\(nameSingleton.addedmember!)/Location/LocationData/Values/l/1")
                
                longRef.observeEventType(.Value , withBlock: { snapshot in
                    print("long value")
                    print(snapshot.value)
                    nameSingleton.memberlats.append("\(snapshot.value)")
                    self.partyMemberTable.reloadData()
                })
        
            let latRef = Firebase(url: "https://hunttracker.firebaseio.com/users/\(nameSingleton.addedmember!)/Location/LocationData/Values/l/0")
        
                latRef.observeEventType(.Value , withBlock: { snapshot in
                    print("lat value")
                    
            print(snapshot.value)
            nameSingleton.memberlongs.append("\(snapshot.value!)")
                    self.partyMemberTable.reloadData()
        })
    }
    
    @IBAction func refreshPressed(sender: AnyObject)
    {
        
            self.partyMemberTable.reloadData()
     
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        print("here")
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! partyMemberCell
        
        
        if(nameSingleton.partymembers.count != 0)
        {
        
        cell.userName.text = ("UserName: \(nameSingleton.partymembers[indexPath.row])")
        cell.longLabel.text = ("Longitude: \(nameSingleton.memberlongs[indexPath.row])")
        cell.latLabel.text = ("Latitude: \(nameSingleton.memberlats[indexPath.row])")
        
        return cell
        }
        else
        {
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    
    }

}

