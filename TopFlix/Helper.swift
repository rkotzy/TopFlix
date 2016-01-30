//
//  Helper.swift
//  TopFlix
//
//  Created by Kotzebue, Ryan (US - San Francisco) on 1/29/16.
//  Copyright © 2016 Kotz. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    static func heightForStringInTextView(width: CGFloat, text: NSString, font: UIFont, buffer: CGFloat) -> CGFloat {
        
        return text.boundingRectWithSize(
            CGSizeMake(width, CGFloat.max),
            options: [NSStringDrawingOptions.UsesLineFragmentOrigin,NSStringDrawingOptions.UsesFontLeading],
            attributes: [NSFontAttributeName : font],
            context: nil).size.height
            + buffer
        
    }
}