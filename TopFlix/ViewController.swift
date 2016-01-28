//
//  ViewController.swift
//  TopFlix
//
//  Created by Kotzebue, Ryan (US - San Francisco) on 1/25/16.
//  Copyright © 2016 Kotz. All rights reserved.
//

import UIKit

import Alamofire
import Kingfisher


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let kTableViewRowHeight : CGFloat = 100
    let kTopMoviesAPIBaseURL = "https://itunes.apple.com/us/rss/topmovies/limit=50/json"
    
    var refreshControl = UIRefreshControl()
    var movies = [MovieInfo]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colors = Colors()
        
        // set background color from Constants color struct
        self.view.backgroundColor = colors.kBackgroundColor
        
        
        // make the title a little prettier
        let titleLabel = UILabel(frame: CGRectMake(0,0,120,40))
        titleLabel.font = UIFont(name: "ForgottenFuturistShadow", size: 35)!
        titleLabel.textAlignment = .Center
        titleLabel.text = "Top Flix"
        titleLabel.textColor = colors.kNavigationTitleColor
        self.navigationItem.titleView = titleLabel

        
        // add a refresh control to the tableview
        refreshControl.addTarget(self, action: "refresAPIData", forControlEvents: .ValueChanged)
        refreshControl.beginRefreshing()
        tableView.addSubview(refreshControl)
        
        // set the delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        // pull data from iTunes API
        refresAPIData()
    }


    // MARK: - Data Methods
    func refresAPIData() {
        
        Alamofire.request(.GET, kTopMoviesAPIBaseURL).validate().responseJSON { response in
            
            //lets start with a fresh movies array for every request
            self.movies.removeAll()
            
            //check the response
            switch response.result {
            
            case .Success:
                if let value = response.result.value {
                    
                    // initialize JSON class with returned data
                    let json = JSON(value)
                    
                    // loop through JSON to populate array
                    for (key, entry) in json["feed"]["entry"] {
                        
                        // create new MovieInfo object and append to movies array
                        let movie = MovieInfo()
                        movie.urlApp = entry["id"]["label"].string
                        movie.name = entry["im:name"]["label"].string
                        movie.urlImage = entry["im:image"][2]["label"].string
                        movie.index = Int(key)
                        movie.summary = entry["summary"]["label"].string
                        movie.previewUrl = entry["link"][1]["attributes"]["href"].string
                        movie.genre = entry["category"]["attributes"]["label"].string
                        movie.releaseDate = entry["im:releaseDate"]["attributes"]["label"].string
                        
                        // add new movie to array
                        self.movies.append(movie)
                    }
                                        
                } else {
                    print("Error retrieving JSON")
                }
            case .Failure(let error):
                print(error)
            }
            
            //reload the tableview regardless of success/failure
            self.reloadData()
        }
    }
    
    func reloadData() {
        
        // load data into the tableview
        tableView.reloadData()
        
        // set the 'Last Updated' label
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        let title = formatter.stringFromDate(NSDate())
        let refreshAttributesDictionary = [NSForegroundColorAttributeName : UIColor.blackColor()]
        let attributedTitle = NSAttributedString(string: title, attributes: refreshAttributesDictionary)
        refreshControl.attributedTitle = attributedTitle
        
        // stop the refresh control
        refreshControl.endRefreshing()
    }
    
    // MARK: - UITableView delegate/datasource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
    
        if movies.count > 0 {
            tableView.separatorStyle = .SingleLine
            tableView.backgroundView = nil
            return 1
            
        } else { //no movies where loaded
            
            // Display a message when no data is loaded to table is empty
            let messageLabel : UILabel = UILabel(frame: self.view.bounds)
            
            messageLabel.text = "No data is currently available. Please pull down to refresh."
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .Center
            messageLabel.font = UIFont.systemFontOfSize(20)
            messageLabel.sizeToFit()
            
            tableView.backgroundView = messageLabel
            tableView.separatorStyle = .None
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kTableViewRowHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // reuse cells from the MovieCell class
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        
        cell.title.text = movie.name
        cell.genre.text = movie.genre
        cell.releaseDate.text = movie.releaseDate
        cell.movieImage.kf_setImageWithURL(NSURL(string: movie.urlImage)!, placeholderImage: nil)
        /*
            Randomly getting a warning here "<memory> is not a BOMStorage file"
            Apple employee says this is harmless here -> https://forums.developer.apple.com/thread/21723
        */
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let movie = movies[indexPath.row]
        movie.image = (tableView.cellForRowAtIndexPath(indexPath) as! MovieCell).movieImage.image
        
        if movie.image == nil {
            // image has not downloaded yet
            return
        }
        
        //create a view controller from the "detailView" in storyboard
        let dvc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("detailView") as! DetailViewController
        
        // set the movie from .movies array
        dvc.movie = movies[indexPath.row]
        
        // push this view controller to navigation stack
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}

