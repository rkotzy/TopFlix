//
//  DataManager.swift
//  TopFlix
//
//  Created by Kotzebue, Ryan (US - San Francisco) on 1/29/16.
//  Copyright © 2016 Kotz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON



let kTopMoviesAPIBaseURL = "https://itunes.apple.com/us/rss/topmovies/limit=50/json"


class DataManager {
    
    func getTopMoviesFromITunes(success: ((movieData: [MovieInfo]!) -> Void)) {

        var movies = [MovieInfo]()
        
        Alamofire.request(.GET, kTopMoviesAPIBaseURL).validate().responseJSON { response in
            
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
                        movies.append(movie)
                    }
                    
                } else {
                    print("Error retrieving JSON")
                }
            case .Failure(let error):
                print(error)
            }
            
            //return MovieInfo array
            success(movieData: movies)
        }
    }
}