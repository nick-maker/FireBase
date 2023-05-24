//
//  FriendViewController.swift
//  NickFireBase
//
//  Created by Nick Liu on 2023/5/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FirestoreDataUpdateDelegate {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.reloadData()
        NSLayoutConstraint.activate(
            [tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
             tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
             tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
             tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            ]
        )
        
        tableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.reuseIdentifier)
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.firestoreDataUpdateDelegate = self
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func acceptFriend(sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else {
            return
        }
        
        let documentID = TabBarController.shared.waitingData[indexPath.row]
        
        db.collection("users").document(User.email).collection("waiting_lists").document(documentID).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        db.collection("users").document(documentID).collection("waiting_lists").document(documentID).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        db.collection("users").document(User.email).collection("friends").document(documentID).setData([
            "email": documentID])
        
        db.collection("users").document(documentID).collection("friends").document(User.email).setData([
            "email": User.email])
    }
    
    @objc func declineFriend(sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else {
            return
        }
        
        let documentID = TabBarController.shared.waitingData[indexPath.row] // Get the document ID based on the row index
        
        db.collection("users").document(User.email).collection("waiting_lists").document(documentID).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "\(TabBarController.shared.waitingData.count)  Invitations"
        } else {
            return "\(TabBarController.shared.friendData.count)  Friends"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Two sections: "Invitations" and "Friends"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return TabBarController.shared.waitingData.count
        } else {
            return TabBarController.shared.friendData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendCell.self), for: indexPath) as? FriendCell else { fatalError("Cannot downcasting")}
            cell.emailLabel.text = TabBarController.shared.waitingData[indexPath.row]
            cell.acceptButton.addTarget(self, action: #selector(acceptFriend), for: .touchUpInside)
            cell.declineButton.addTarget(self, action: #selector(declineFriend), for: .touchUpInside)
            cell.acceptButton.isHidden = false
            cell.declineButton.isHidden = false
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendCell.self), for: indexPath) as? FriendCell else { fatalError("Cannot downcasting")}
            cell.acceptButton.isHidden = true
            cell.declineButton.isHidden = true
            cell.emailLabel.text = TabBarController.shared.friendData[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func firestoreDataUpdated() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
}
