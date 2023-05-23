//
//  FriendCell.swift
//  NickFireBase
//
//  Created by Nick Liu on 2023/5/23.
//

import UIKit

class FriendCell: UITableViewCell {

    static let reuseIdentifier = "\(FriendCell.self)"
    
    
    var emailLabel = UILabel()
    var declineButton = UIButton()
    var acceptButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [emailLabel, declineButton, acceptButton].forEach { contentView.addSubview($0)}
        [ emailLabel, declineButton, acceptButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        emailLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.setTitleColor(.systemGreen, for: .normal)
        acceptButton.titleLabel!.font = UIFont(name: "Helvetica Neue" , size: 14)
        declineButton.titleLabel!.font = UIFont(name: "Helvetica Neue" , size: 14)
        declineButton.setTitle("Decline", for: .normal)
        declineButton.setTitleColor(.red, for: .normal)
        NSLayoutConstraint.activate([
            
            emailLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emailLabel.widthAnchor.constraint(equalToConstant: 230),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            acceptButton .topAnchor.constraint(equalTo: emailLabel.topAnchor),
            acceptButton.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 8),
            acceptButton.heightAnchor.constraint(equalToConstant: 20),
            acceptButton.widthAnchor.constraint(equalToConstant: 60),
            
            
            declineButton.topAnchor.constraint(equalTo: emailLabel.topAnchor),
            declineButton.leadingAnchor.constraint(equalTo: acceptButton.trailingAnchor, constant: 8),
            declineButton.heightAnchor.constraint(equalToConstant: 20),
            declineButton.widthAnchor.constraint(equalToConstant: 60),
            
            ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
