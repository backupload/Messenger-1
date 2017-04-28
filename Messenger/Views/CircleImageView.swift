//
//  CircleImageView.swift
//  Messenger
//
//  Created by didYouUpdateCode on 2017/4/21.
//  Copyright © 2017年 didYouUpdateCode. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    
    override func layoutSubviews() {
        contentMode = .scaleAspectFill
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
    
}
