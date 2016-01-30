//
//  EmptyTableBackgroundMessage.swift
//  TopFlix
//
//  Created by Kotzebue, Ryan (US - San Francisco) on 1/29/16.
//  Copyright © 2016 Kotz. All rights reserved.
//

import UIKit

class EmptyTableBackgroundMessage: UILabel {
    
    let kEmptyTableBackgroundMessage = "No data is currently available. Please pull down to refresh."
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Display a message when no data is loaded to table is empty
        self.text = kEmptyTableBackgroundMessage
        self.numberOfLines = 0
        self.textAlignment = .Center
        self.font = UIFont.systemFontOfSize(20)
        self.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
