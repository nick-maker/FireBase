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
        addData()
//        getData()
        
        titleTextField.text = ""
        contentField.text = ""
        beautyButton.isEnabled = true
        gossipButton.isEnabled = true
        schoolLife.isEnabled = true
        
    }
    
    let db = Firestore.firestore()
    var titleText: String?
    var contentText: String?
    var tag: String?
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        contentField.delegate = self
        listen()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        titleText = titleTextField.text
        contentText = contentField.text
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
    
    func getData() {
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.data())")
                }
            }
        }
    }
    
    func listen() {
        db.collection("posts").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error listening for changes: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents available")
                return
            }
            
            for document in documents {
                print("\(document.data())")
            }
        }
    }
    

    
}

