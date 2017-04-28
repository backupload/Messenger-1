//
//  BaseTableViewCell.swift
//  Messenger
//
//  Created by didYouUpdateCode on 2017/4/21.
//  Copyright © 2017年 didYouUpdateCode. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        //fatalError("Not implemented")
    }
}
