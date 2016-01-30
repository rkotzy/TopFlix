//
//  SeperatorCell.swift
//  TopFlix
//
//  Created by Kotzebue, Ryan (US - San Francisco) on 1/29/16.
//  Copyright © 2016 Kotz. All rights reserved.
//

import UIKit

class SeperatorCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // add custom 'seperator' views if they are hidden on the uitableview
        let color = Colors.kSeperatorColor
        
        let lowerLine = UIView(frame: CGRectMake(0, self.frame.height - 1,self.frame.width,1))
        lowerLine.backgroundColor = color
        self.addSubview(lowerLine)
        
        let upperLine = UIView(frame: CGRectMake(0, 0,self.frame.width,1))
        upperLine.backgroundColor = color
        self.addSubview(upperLine)
        
    }

}
