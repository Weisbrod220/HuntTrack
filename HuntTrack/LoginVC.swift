//
//  LoginVC.swift
//  HuntTrack
//
//  Created by Evan Weisbrod on 3/29/16.
//  Copyright © 2016 Evan Weisbrod. All rights reserved.
//

import UIKit
import QuartzCore
import Firebase

class LoginVC: UIViewController {
    
    // MARK: Constants
    let LoginToList = "LoginToList"
    
    // MARK: Outlets
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    // MARK: Properties
    let ref = Firebase(url: "https://hunttracker.firebaseio.com/")
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ref.observeAuthEventWithBlock { (authData) -> Void in
            
            if authData != nil {
                self.performSegueWithIdentifier(self.LoginToList, sender: nil)
            }
            
        }
    }
    
    // MARK: Actions
    @IBAction func loginDidTouch(sender: AnyObject) {
        nameSingleton.currUsername = textFieldUsername.text
        ref.authUser(textFieldLoginEmail.text, password: textFieldLoginPassword.text, withCompletionBlock: { (error, auth) -> Void in
         
            nameSingleton.defaults.setObject(self.textFieldUsername.text, forKey: "Username")
            self.getdata()
           
        })
        
    }
    
    func getdata()
    {
        print("first stop")
        let partmemref = Firebase(url: "https://hunttracker.firebaseio.com/users/\(nameSingleton.currUsername!)/PartyMembers/")
        partmemref.observeEventType(.ChildAdded, withBlock: {
            snapshot in
            
            print(snapshot.key)
            print(snapshot.value)
            print(snapshot.value.valueForKey("Lat")!)
            nameSingleton.memberlats.append(snapshot.value.valueForKey("Lat")! as! String)
            print(snapshot.value.valueForKey("Long")!)
            nameSingleton.memberlongs.append(snapshot.value.valueForKey("Long")! as! String)
            print(snapshot.value.valueForKey("PartyMember")!)
           // nameSingleton.memberslist.append(snapshot.value.valueForKey("PartyMember")! as! String)
            nameSingleton.partymembers.append(snapshot.value.valueForKey("PartyMember")! as! String)
            print(nameSingleton.memberslist)
            print("Im here")
        })
       
    }
    
    @IBAction func signUpDidTouch(sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
            message: "Register",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default) { (action: UIAlertAction) -> Void in
                
                let emailField = alert.textFields![0]
                let passwordField = alert.textFields![1]
                nameSingleton.currUsername = alert.textFields![2].text
                print(nameSingleton.currUsername)
                
                self.ref.createUser(emailField.text, password: passwordField.text) { (error: NSError!) in
                    
                    if error == nil {
                        
                        self.ref.authUser(emailField.text, password: passwordField.text, withCompletionBlock: { (error, auth) in
                            
                        })
                    }
                }
                
                
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textEmail) -> Void in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textPassword) -> Void in
            textPassword.secureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        alert.addTextFieldWithConfigurationHandler {
            (textName) -> Void in
            textName.placeholder = "Enter your Username"
            
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
}

