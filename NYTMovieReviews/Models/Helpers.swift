//
//  Helpers.swift
//  NYTMovieReviews
//
//  Created by Luis Calle on 12/14/17.
//  Copyright © 2017 Luis Calle. All rights reserved.
//

import Foundation
import UIKit

enum AppError: Error {
    case noData
    case noInternet
    case couldNotParseJSON(rawError: Error)
    case badURL(str: String)
    case urlError(rawError: URLError)
    case otherError(rawError: Error)
}

struct NetworkHelper {
    private init() { }
    static let manager = NetworkHelper()
    
    let session = URLSession(configuration: .default)
    func performDataTask(with request: URLRequest, completionHandler: @escaping (Data) -> Void, errorHandler: @escaping (Error) -> Void) {
        let myDataTask = session.dataTask(with: request){(data, responcse, error) in
            DispatchQueue.main.async {
                guard let data = data else { errorHandler(AppError.noData); return }
                if let error = error as? URLError {
                    switch error {
                    case URLError.notConnectedToInternet:
                        errorHandler(AppError.noInternet)
                        return
                    default:
                        errorHandler(AppError.urlError(rawError: error))
                    }
                } else {
                    if let error = error {
                        errorHandler(AppError.otherError(rawError: error))
                    }
                }
                completionHandler(data)
            }
        }
        myDataTask.resume()
    }
}

struct ImageFetchHelper {
    private init() {}
    static let manager = ImageFetchHelper()
    
    func getImage(from urlStr: String, completionHandler: @escaping (UIImage) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else { return }
        let completion: (Data) -> Void = { (data: Data) in
            guard let onlineImage = UIImage(data: data) else { return }
            completionHandler(onlineImage)
        }
        let request = URLRequest(url: url)
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}
