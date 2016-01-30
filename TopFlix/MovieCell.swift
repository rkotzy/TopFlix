//
//  MovieCell.swift
//  TopFlix
//
//  Created by Kotzebue, Ryan (US - San Francisco) on 1/25/16.
//  Copyright © 2016 Kotz. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    func defineFromMovieInfo(movie: MovieInfo) {
        title.text = movie.name
        genre.text = movie.genre
        releaseDate.text = movie.releaseDate
        movieImage.kf_setImageWithURL(NSURL(string: movie.urlImage)!, placeholderImage: nil)
    }

}
