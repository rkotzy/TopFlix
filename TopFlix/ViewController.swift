//
//  ViewController.swift
//  TopFlix
//
//  Created by Kotzebue, Ryan (US - San Francisco) on 1/25/16.
//  Copyright © 2016 Kotz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let kTopMoviesReturnCountLimit = 50
    let kTableViewRowHeight : CGFloat = 100
    
    let apiManager = DataManager()
    var refreshControl : LastUpdatedRefreshControl!
    
    var movies = [MovieInfo]()
    
    
    // MARK: - Layout
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // set background color from Constants color struct
        self.view.backgroundColor = Colors.kBackgroundColor
        
        
        // make the title a little prettier
        self.navigationItem.titleView = NavigationBarTitleView(title: "Top Flix")

        
        // add a refresh control to the tableview
        refreshControl = LastUpdatedRefreshControl()
        refreshControl.addTarget(self, action: "refreshTopMoviesData", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        // set the delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        // pull data from iTunes API
        refreshTopMoviesData()
        
    }


    // MARK: - Data Methods
    func refreshTopMoviesData() {
                
        apiManager.getTopMoviesFromITunes({ movieData in
            
            self.movies = movieData
            
            // load data into the tableview
            self.tableView.reloadData()
            
            // stop the refresh control
            self.refreshControl.endRefreshing()

        })
    }
    
    // MARK: - UITableView delegate/datasource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if movies.count > 0 {
            tableView.separatorStyle = .SingleLine
            tableView.backgroundView = nil
            return 1
            
        } else { //no movies where loaded
            tableView.backgroundView = EmptyTableBackgroundMessage(frame: tableView.frame)
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
        cell.defineFromMovieInfo(movies[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let movie = movies[indexPath.row]
        
        guard let image = (tableView.cellForRowAtIndexPath(indexPath) as! MovieCell).movieImage.image else {
            // don't show detail if image hasn't downloaded yet
            return
        }
        
        movie.image = image
        
        let detailViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("detailView") as! DetailViewController
        
        // set the movie from .movies array
        detailViewController.movie = movies[indexPath.row]
        
        // push this view controller to navigation stack
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

