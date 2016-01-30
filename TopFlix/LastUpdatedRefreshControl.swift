//
//  LastUpdatedRefreshControl.swift
//  TopFlix
//
//  Created by Kotzebue, Ryan (US - San Francisco) on 1/29/16.
//  Copyright © 2016 Kotz. All rights reserved.
//

import UIKit

class LastUpdatedRefreshControl: UIRefreshControl {
    
    override func endRefreshing() {
        
        // set the 'Last Updated' label
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        let title = formatter.stringFromDate(NSDate())
        let refreshAttributesDictionary = [NSForegroundColorAttributeName : UIColor.blackColor()]
        let attributedTitle = NSAttributedString(string: title, attributes: refreshAttributesDictionary)
        self.attributedTitle = attributedTitle
        
        // stop the refresh control
        if self.refreshing {
            super.endRefreshing()
        }
    }

}
