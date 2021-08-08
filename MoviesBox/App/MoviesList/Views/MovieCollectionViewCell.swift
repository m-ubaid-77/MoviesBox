//
//  MovieCollectionViewCell.swift
//  MoviesBox
//
//  Created by Muhammad Ubaid on 05/08/2021.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie : Movie!
    
    func configureCell(movie:Movie) {
        self.movie = movie
        titleLabel.text = movie.original_title;
        releaseDateLabel.text = movie.release_date;
        descriptionLabel.text = movie.overview;
        
        if let releaseDate = movie.release_date {
            releaseDateLabel.text = DateUtility.formatedDate(date: releaseDate, From: "yyyy-MM-dd", To: "dd MMMM, yyyy")
        } else {
            releaseDateLabel.text = ""
        }
        
        
        posterImageView.image = nil
        
        if let posterImage = movie.poster_path {
            ImageUtility.getMoviePosterImage(from: APIManager.moviesPosterBasePath, with: posterImage) { [weak self](image) in
                guard let self = self else{return}
                DispatchQueue.main.async {
                    self.posterImageView.image = image
                }
            }
        } else {
            posterImageView.image = UIImage(named: "moviesPosterPlaceholder")
        }
    }
}
