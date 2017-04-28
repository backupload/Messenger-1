//
//  RecentCell.swift
//  Messenger
//
//  Created by didYouUpdateCode on 2017/4/21.
//  Copyright © 2017年 didYouUpdateCode. All rights reserved.
//

import UIKit

class RecentCell: BaseTableViewCell {
    
    // MARK: - Public properties
    static let identifier = String(describing: RecentCell.self)
    
    var lastMessage: Message? {
        willSet {
            nameLabel.text = newValue?.friend?.name
            
            if let imageName = newValue?.friend?.profileImageName {
                profilePicture.image = UIImage(named: imageName)
                hasReadImageView.image = profilePicture.image
            }
            
            messageLabel.text = newValue?.text
            
            if let date = newValue?.date as? Date {
                let now = Date()
                let dateFomatter = DateFormatter()
                
                if dateFomatter.calendar.isDateInToday(date) {
                    dateFomatter.dateFormat = "hh:mm a"
                } else if dateFomatter.calendar.compare(now, to: date, toGranularity: .year) == .orderedSame {
                    if dateFomatter.calendar.compare(now, to: date, toGranularity: .weekOfYear) == .orderedSame {
                        dateFomatter.dateFormat = "EEE"
                    } else {
                        dateFomatter.dateFormat = "dd MMM"
                    }
                } else {
                    dateFomatter.dateFormat = "MM/dd/yy"
                }
                
                dateLabel.text = dateFomatter.string(from: date)
            }
        }
    }
    
    
    // MARK: - UI components
    private let profilePicture: CircleImageView = {
        let imageView = CircleImageView()
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    private let hasReadImageView: CircleImageView = {
        let imageView = CircleImageView()
        return imageView
    }()
    
    
    override func setupViews() {
        selectionStyle = .none
        setupProfilePicture(in: contentView.layoutMarginsGuide)
        setupContainer(in: contentView.layoutMarginsGuide)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: true)
        backgroundColor = highlighted ? UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1) : .white
        nameLabel.textColor = highlighted ? .white : .black
        dateLabel.textColor = highlighted ? .white : .gray
        messageLabel.textColor = highlighted ? .white : .gray
    }
    
    
    // MARK: - Autolayout
    private func setupProfilePicture(in layoutGuide: UILayoutGuide) {
        contentView.addSubview(profilePicture)
        
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        profilePicture.heightAnchor.constraint(equalTo: profilePicture.widthAnchor).isActive = true
        profilePicture.heightAnchor.constraint(equalTo: layoutGuide.heightAnchor).isActive = true
        profilePicture.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive = true
    }
    
    private func setupContainer(in layoutGuide: UILayoutGuide) {
        let containerLayoutGuide = UILayoutGuide()
        contentView.addLayoutGuide(containerLayoutGuide)
        
        setupNameLabel(in: containerLayoutGuide)
        setupMessageLabel(in: containerLayoutGuide)
        setupDateLabel(in: containerLayoutGuide)
        setupHasReadImageView(in: containerLayoutGuide)
        
        containerLayoutGuide.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 15).isActive = true
        containerLayoutGuide.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        containerLayoutGuide.centerYAnchor.constraint(equalTo: profilePicture.centerYAnchor).isActive = true
    }
    
    private func setupNameLabel(in layoutGuide: UILayoutGuide) {
        contentView.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
    }
    
    private func setupMessageLabel(in layoutGuide: UILayoutGuide) {
        contentView.addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupDateLabel(in layoutGuide: UILayoutGuide) {
        contentView.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
    }
    
    private func setupHasReadImageView(in layoutGuide: UILayoutGuide) {
        contentView.addSubview(hasReadImageView)
        
        hasReadImageView.translatesAutoresizingMaskIntoConstraints = false
        hasReadImageView.leadingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 8).isActive = true
        hasReadImageView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        hasReadImageView.heightAnchor.constraint(equalTo: hasReadImageView.widthAnchor).isActive = true
        hasReadImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        hasReadImageView.centerYAnchor.constraint(equalTo: messageLabel.centerYAnchor).isActive = true
    }
}
