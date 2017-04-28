//
//  ChatCell.swift
//  Messenger
//
//  Created by didYouUpdateCode on 2017/4/25.
//  Copyright © 2017年 didYouUpdateCode. All rights reserved.
//

import UIKit

class ChatCell: BaseTableViewCell {
    
    static let identifier = String(describing: ChatCell.self)
    
    var message: Message? {
        didSet {
            messageLabel.text = message?.text
            
            if let imageName = message?.friend?.profileImageName {
                profileImageView.image = UIImage(named: imageName)
            }
            
            if let isSender = message?.isSender, isSender {
                bubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                messageLabel.textColor = .white
            } else {
                bubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                messageLabel.textColor = .black
            }
            
            layoutIfNeeded()
        }
    }
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let profileImageView: CircleImageView = {
        return CircleImageView()
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override func setupViews() {
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        
        layoutProfileImage()
        layoutBubbleView()
        layoutMessageLabel()
    }
    
    private func layoutProfileImage() {
        guard let message = message else {
            return
        }
        
        if !message.isSender {
            let layoutGuide = contentView.layoutMarginsGuide
            
            contentView.addSubview(profileImageView)
            
            profileImageView.translatesAutoresizingMaskIntoConstraints = false
            profileImageView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: -8).isActive = true
            profileImageView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
    }
    
    private func layoutBubbleView() {
        guard let message = message else {
            return
        }
        
        let layoutGuide = contentView.layoutMarginsGuide
        
        contentView.addSubview(bubbleView)
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
        
        if !message.isSender {
            bubbleView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        } else {
            bubbleView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: 8).isActive = true
        }
    }
    
    private func layoutMessageLabel() {
        guard let _ = message else {
            return
        }
        
        let layoutGuide = bubbleView.layoutMarginsGuide
        
        bubbleView.addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
    }
}
