//
//  TabBarController.swift
//  NickFireBase
//
//  Created by Nick Liu on 2023/5/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    static let shared = TabBarController()
    
    let db = Firestore.firestore()
    var count = 0
    var waitingData: [String] = []
    var friendData: [String] = []
    weak var firestoreDataUpdateDelegate: FirestoreDataUpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        listenFriendRequest()
    }
    
    func listenFriendRequest() {
        db.collection("users").document("hybrida666@gmail.com").collection("waiting_lists").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
            }
            
            let email = documents.map { $0.documentID }
//            let emailKey = documents.compactMap { $0.data()["email"] as? String}
//            print(emailKey)
            self.waitingData = email
            self.count = documents.count
            self.updateBadge()
            self.firestoreDataUpdateDelegate?.firestoreDataUpdated()
        }
        
        db.collection("users").document("hybrida666@gmail.com").collection("friends").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
            }
            
            let email = documents.map {$0.documentID }
            self.friendData = email
            self.firestoreDataUpdateDelegate?.firestoreDataUpdated()
            print(self.friendData)
        }
        
    }
    
    
    
    func updateBadge() {
        if let tabBarItem = self.tabBar.items?[1] {
            if count > 0 {
                tabBarItem.badgeValue = "\(count)"
            } else {
                tabBarItem.badgeValue = nil
            }
        }
    }
    
}

protocol FirestoreDataUpdateDelegate: AnyObject {
    func firestoreDataUpdated()
}
