//
//  ViewController.swift
//  NickFireBase
//
//  Created by Nick Liu on 2023/5/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var friendButton: UIButton!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var contentField: UITextField!
    
    @IBOutlet weak var beautyButton: UIButton!
    
    @IBOutlet weak var gossipButton: UIButton!
    
    @IBOutlet weak var schoolLife: UIButton!
    
    @IBOutlet weak var publishButton: UIButton!
    
    @IBAction func tagTapped(_ sender: UIButton) {
        beautyButton.isEnabled = false
        gossipButton.isEnabled = false
        schoolLife.isEnabled = false
        sender.isEnabled = true
        if sender == beautyButton {
                tag = "Beauty"
            } else if sender == gossipButton {
                tag = "Gossiping"
            } else if sender == schoolLife {
                tag = "SchoolLife"
            } else {
                tag = nil
            }
        contentField.resignFirstResponder()
    }
    
    @IBAction func publishAction(_ sender: UIButton) {
        titleTextField.text = ""
        contentField.text = ""
        beautyButton.isEnabled = true
        gossipButton.isEnabled = true
        schoolLife.isEnabled = true
    }
    
    let db = Firestore.firestore()
    let email = "hybrida666@gmail.com"
    var titleText: String?
    var contentText: String?
    var tag: String?
    var targetEmail: String?
    var friendText: String?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        addUser()
        titleTextField.delegate = self
        contentField.delegate = self
        searchTextField.delegate = self
        nameLabel.isHidden = true
        friendButton.isEnabled = false
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        addFriend()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            titleText = titleTextField.text
            contentText = contentField.text
            targetEmail = searchTextField.text
            checkUser()
            textField.resignFirstResponder()
            return false
        }
        return true
    }

    func addData() {
        let newRef = db.collection("posts").document()
        newRef.setData([
            "id": newRef.documentID,
            "title": titleText!,
            "content": contentText!,
            "tag": tag!,
            "author_id": "hybrida666",
            "created_time": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func checkUser() {
        guard targetEmail != email else {
            print("cannot add yourself as friend")
            return }
        let target = db.collection("users").document(targetEmail!)
        target.getDocument { (document, error) in
            if let document = document, document.exists {
                self.friendButton.isEnabled = true
                self.nameLabel.isHidden = false
                self.nameLabel.text = document["name"] as? String
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func addUser() {
        db.collection("users").document(email).setData([
            "id": "hybrida666",
            "email": email,
            "name": "Nick"
        ]){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func addFriend() {
        let target = db.collection("users").document(targetEmail!)
        
        target.getDocument { [weak self] (document, error) in
            guard let document = document, document.exists else {
                print("Document does not exist")
                return
            }
            guard let self = self else {
                return
            }
            let targetFriendsCollection = target.collection("friends")
            
            targetFriendsCollection.document(self.email).getDocument { (friendDocument, friendError) in
                guard let friendDocument = friendDocument, !friendDocument.exists else {
                    print("Already friends") // Already friends, handle accordingly
                    return
                }
                
                let targetWaitingListsCollection = target.collection("waiting_lists")
                targetWaitingListsCollection.document(self.email).setData([
                    "email": self.email
                ]) { error in
                    if let error = error {
                        print("Error adding to waiting list: \(error)")
                    } else {
                        print("Added to waiting list successfully")
                    }
                }
            }
        }
    }
    
//    func listen() {
//        db.collection("posts").addSnapshotListener { querySnapshot, error in
//            if let error = error {
//                print("Error listening for changes: \(error)")
//                return
//            }
//
//            guard let documents = querySnapshot?.documents else {
//                print("No documents available")
//                return
//            }
//
//            for document in documents {
//                print("\(document.data())")
//            }
//        }
//    }
    

    
}

