//
//  NavigationBarTitleView.swift
//  TopFlix
//
//  Created by Kotzebue, Ryan (US - San Francisco) on 1/29/16.
//  Copyright © 2016 Kotz. All rights reserved.
//

import UIKit

class NavigationBarTitleView: UILabel {
    
    init(title: String) {
        super.init(frame: CGRectMake(0,0,120,40))
        
        // make the title a little prettier
        self.font = UIFont(name: "ForgottenFuturistShadow", size: 35)!
        self.textAlignment = .Center
        self.text = title
        self.textColor = Colors.kNavigationTitleColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
