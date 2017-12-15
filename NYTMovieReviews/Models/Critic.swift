//
//  Critic.swift
//  NYTMovieReviews
//
//  Created by Luis Calle on 12/14/17.
//  Copyright © 2017 Luis Calle. All rights reserved.
//

import Foundation

struct CriticsResponse: Codable {
    let results: [Critic]
}

struct Critic: Codable {
    let display_name: String
    let seo_name: String
    let multimedia: MultimediaWrapper?
}

struct MultimediaWrapper: Codable {
    let resource: ResourceWrapper
}

struct ResourceWrapper: Codable {
    let type: String
    let src: String
}

struct CriticAPIClient {
    private init() {}
    static let manager = CriticAPIClient()
    
    let apiKey = "625d90145c754087a4e16200c1bbdfb6"
    let urlStr = "https://api.nytimes.com/svc/movies/v2/critics/all.json?api-key="
    func getCritics(completionHandler: @escaping ([Critic]) -> Void, errorHandler: @escaping (Error) -> Void) {
        let fullUrl = urlStr + apiKey
        guard let url = URL(string: fullUrl) else {
            errorHandler(AppError.badURL(str: fullUrl))
            return
        }
        let urlRequest = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let criticsResponse = try JSONDecoder().decode(CriticsResponse.self, from: data)
                completionHandler(criticsResponse.results)
            }
            catch {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: urlRequest, completionHandler: completion, errorHandler: errorHandler)
    }
}
