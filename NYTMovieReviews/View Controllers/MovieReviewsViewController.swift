//
//  ViewController.swift
//  NYTMovieReviews
//
//  Created by Luis Calle on 12/14/17.
//  Copyright © 2017 Luis Calle. All rights reserved.
//

import UIKit

class MovieReviewsViewController: UIViewController {
    
    @IBOutlet weak var criticsTableView: UITableView!
    @IBOutlet weak var movieReviewsCollectionView: UICollectionView!
    
    var allCritics = [Critic]() {
        didSet {
            self.criticsTableView.reloadData()
        }
    }
    
    var moviesReviewed = [MovieReview]() {
        didSet {
            self.movieReviewsCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.criticsTableView.dataSource = self
        self.criticsTableView.delegate = self
        self.movieReviewsCollectionView.dataSource = self
        self.movieReviewsCollectionView.delegate = self
        loadCritics()
    }
    
    func loadCritics() {
    CriticAPIClient.manager.getCritics(completionHandler: { self.allCritics = $0 }, errorHandler: { print($0) })
    }
    
    func loadMovieReviews(reviewer: String) {
        MovieReviewAPIClient.manager.getMovieReviews(reviewer: reviewer, completionHandler: { self.moviesReviewed = $0 }, errorHandler: { print($0) })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieReviewDetailViewController {
            guard let selectedCell = sender as? MovieReviewCollectionViewCell else { return }
            guard let indexPath = movieReviewsCollectionView.indexPath(for: selectedCell) else { return  }
            let selectedReview = moviesReviewed[indexPath.row]
            destination.movieReview = selectedReview
        }
    }

}

extension MovieReviewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCritics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let criticCell = tableView.dequeueReusableCell(withIdentifier: "Critic Cell", for: indexPath)
        if let criticCell = criticCell as? CriticTableViewCell {
            criticCell.imageSpinner.isHidden = false
            criticCell.imageSpinner.startAnimating()
            let selectedCritic = allCritics[indexPath.row]
            criticCell.criticNameLabel.text = selectedCritic.display_name
            criticCell.criticImage.image = nil
            guard let criticMultimedia = selectedCritic.multimedia else {
                criticCell.imageSpinner.isHidden = true
                criticCell.imageSpinner.stopAnimating()
                criticCell.criticImage.image = UIImage(named: "image_not_found")
                return criticCell
            }
            let criticImage = criticMultimedia.resource.src
            ImageFetchHelper.manager.getImage(from: criticImage,
                                            completionHandler: {
                                                criticCell.imageSpinner.isHidden = true
                                                criticCell.imageSpinner.stopAnimating()
                                                criticCell.criticImage.image = $0;
                                                criticCell.setNeedsLayout()
                                            },
                                            errorHandler: { print($0) })
        }
        return criticCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadMovieReviews(reviewer: allCritics[indexPath.row].display_name)
    }
    
}

extension MovieReviewsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesReviewed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieReviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Movie Review Cell", for: indexPath) as? MovieReviewCollectionViewCell else {
            return UICollectionViewCell()
        }
        movieReviewCell.movieImageSpinner.isHidden = false
        movieReviewCell.movieImageSpinner.startAnimating()
        let review = moviesReviewed[indexPath.row]
        movieReviewCell.movieTitleLabel.text = review.display_title
        movieReviewCell.movieImage.image = nil
        guard let reviewImageMultimedia = review.multimedia else {
            movieReviewCell.movieImageSpinner.isHidden = true
            movieReviewCell.movieImageSpinner.stopAnimating()
            movieReviewCell.movieImage.image = UIImage(named: "image_not_found")
            return movieReviewCell
        }
        let reviewImageUrl = reviewImageMultimedia.src
        ImageFetchHelper.manager.getImage(from: reviewImageUrl,
                                          completionHandler: {
                                            movieReviewCell.movieImageSpinner.isHidden = true
                                            movieReviewCell.movieImageSpinner.stopAnimating()
                                            movieReviewCell.movieImage.image = $0;
                                            movieReviewCell.setNeedsLayout()
        },
                                          errorHandler: { print($0) })
        return movieReviewCell
    }
    
}
