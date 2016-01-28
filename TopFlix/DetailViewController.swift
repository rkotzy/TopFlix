//
//  DetailViewController.swift
//  TopFlix
//
//  Created by Kotzebue, Ryan (US - San Francisco) on 1/25/16.
//  Copyright © 2016 Kotz. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let kPreviewCellIndex = 0
    let kViewCellIndex = 1
    let kSummaryCellIndex = 2
    
    let kPreviewCellHeight : CGFloat = 200
    
    var movie = MovieInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // set background color from Constants color struct
        self.view.backgroundColor = Colors().kBackgroundColor
        
        // set delegates
        tableView.dataSource = self
        tableView.delegate = self
        
        // make a pretty back button
        let backButton = UIBarButtonItem()
        backButton.setFAIcon(.FAChevronLeft, iconSize: 20.0)
        backButton.target = self
        backButton.action = "backButton"
        self.navigationItem.leftBarButtonItem = backButton
                
    }
    
    // MARK: - UITableView delegate/datasource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.row {
        case kPreviewCellIndex:
            return kPreviewCellHeight
        case kSummaryCellIndex:
            let font = UIFont.systemFontOfSize(14.0)
            let text : NSString = movie.summary
            let size = CGSizeMake(tableView.frame.size.width - 32, CGFloat.max)
            let height = text.boundingRectWithSize(size, options: [NSStringDrawingOptions.UsesLineFragmentOrigin,NSStringDrawingOptions.UsesFontLeading], attributes: [NSFontAttributeName : font], context: nil).size.height

            return height + 100
        default:
            return 44
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == kPreviewCellIndex {
            let previewCell = tableView.dequeueReusableCellWithIdentifier("PreviewCell") as! PreviewCell
            
            previewCell.title.text = movie.name
            previewCell.genre.text = movie.genre
            previewCell.releaseDate.text = movie.releaseDate
            previewCell.movieImage.image = movie.image
            
            return previewCell
            
        } else if indexPath.row == kViewCellIndex {
            let viewCell = tableView.dequeueReusableCellWithIdentifier("ViewCell")!
            
            // add custom 'seperator' views since they are hidden on the uitableview
            let lowerLine = UIView(frame: CGRectMake(0, viewCell.frame.height - 1,viewCell.frame.width,1))
            lowerLine.backgroundColor = Colors().kSeperatorColor
            viewCell.addSubview(lowerLine)
            let upperLine = UIView(frame: CGRectMake(0, 0,viewCell.frame.width,1))
            upperLine.backgroundColor = Colors().kSeperatorColor
            viewCell.addSubview(upperLine)
            
            return viewCell
            
        } else if indexPath.row == kSummaryCellIndex {
            let summaryCell = tableView.dequeueReusableCellWithIdentifier("SummaryCell") as! SummaryCell
            summaryCell.summaryTextView.text = movie.summary
            return summaryCell
        }
        
        print("Error setting tableView cells")
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row == kViewCellIndex {
            return true
        }
        
        return false
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.row == kViewCellIndex {
            
            /*
            INFO: The url below cannot open in Simulater because
            Simulator is missing the iTunes Store app.
            Run on device to open link in iTunes Store
            */
            if let url = NSURL(string: movie.urlApp) {
                if UIApplication.sharedApplication().canOpenURL(url) {
                    UIApplication.sharedApplication().openURL(url)
                } else {
                    print("Cannot open url: \(url) on this device")
                }
            }
        }
    }
    
    // MARK: - Navigation
    func backButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
