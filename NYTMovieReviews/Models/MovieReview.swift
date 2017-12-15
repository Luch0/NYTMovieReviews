//
//  MovieReview.swift
//  NYTMovieReviews
//
//  Created by Luis Calle on 12/14/17.
//  Copyright © 2017 Luis Calle. All rights reserved.
//

import Foundation

struct MovieReviewsResponse: Codable {
    let num_results: Int
    let results: [MovieReview]
}

struct MovieReview: Codable {
    let display_title: String
    let mpaa_rating: String
    let critics_pick: Int
    let headline: String
    let summary_short: String
    let publication_date: String
    let opening_date: String?
    let date_updated: String?
    let multimedia: MultimediaReviewWrapper?
}

struct MultimediaReviewWrapper: Codable {
    let type: String
    let src: String
}

struct MovieReviewAPIClient {
    private init() {}
    static let manager = MovieReviewAPIClient()
    let apiKey = "625d90145c754087a4e16200c1bbdfb6"
    func getMovieReviews(reviewer: String, completionHandler: @escaping ([MovieReview]) -> Void, errorHandler: @escaping (Error) -> Void) {
        let urlStr = "https://api.nytimes.com/svc/movies/v2/reviews/search.json?api-key=\(apiKey)&reviewer=\(reviewer.replacingOccurrences(of: " ", with: "%20"))"
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL(str: urlStr))
            return
        }
        let urlRequest = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let movieReviewsResponse = try JSONDecoder().decode(MovieReviewsResponse.self, from: data)
                completionHandler(movieReviewsResponse.results)
            }
            catch {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: urlRequest, completionHandler: completion, errorHandler: errorHandler)
    }
}

