//
//  MovieReviewDetailViewController.swift
//  NYTMovieReviews
//
//  Created by Luis Calle on 12/14/17.
//  Copyright © 2017 Luis Calle. All rights reserved.
//

import UIKit

class MovieReviewDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var mpaaRatingLabel: UILabel!
    @IBOutlet weak var criticPickLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var shortSummaryTextView: UITextView!
    @IBOutlet weak var publicationDateLabel: UILabel!
    @IBOutlet weak var imageReviewSpinner: UIActivityIndicatorView!
    
    var movieReview: MovieReview?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let movieReview = movieReview else { return }
        imageReviewSpinner.startAnimating()
        titleLabel.text = movieReview.display_title
        mpaaRatingLabel.text = "MPAA Rating: \(movieReview.mpaa_rating)"
        criticPickLabel.text = "Critics Pick: \(movieReview.critics_pick)"
        headlineLabel.text = movieReview.headline
        shortSummaryTextView.text = movieReview.summary_short
        publicationDateLabel.text = "Publication Date: \(movieReview.publication_date)"
        guard let reviewImageMultimedia = movieReview.multimedia else {
            imageReviewSpinner.isHidden = true
            imageReviewSpinner.stopAnimating()
            reviewImageView.image = UIImage(named: "image_not_found")
            return
        }
        let reviewImageUrl = reviewImageMultimedia.src
        ImageFetchHelper.manager.getImage(from: reviewImageUrl,
                                          completionHandler: {
                                            self.imageReviewSpinner.isHidden = true
                                            self.imageReviewSpinner.stopAnimating()
                                            self.reviewImageView.image = $0
                                            self.reviewImageView.setNeedsLayout()
                                          },
                                          errorHandler: { print($0) })
    }

}
