//
//  NetworkManager.swift
//  ProductHuntAssignment
//
//  Created by Nicholas Kearns on 4/22/20.
//  Copyright © 2020 Nicholas Kearns. All rights reserved.
//

import Foundation


class NetworkManager {
    
    
    
    
    
    // shared singleton session object used to run tasks. Will be useful later
    let urlSession = URLSession.shared
    
    var baseURL = "https://api.producthunt.com/v1/"
    var token = "t3OMg_m8JuRleWQor6Vqd52GevzGKUFTdSuS-jzoBKc"
    
    
    
    
    // All the code we did before but cleaned up into their own methods
    private func makeRequest(for endPoint: EndPoints) -> URLRequest {
        // grab the parameters from the endpoint and convert them into a string
        let stringParams = endPoint.paramsToString()
        // get the path of the endpoint
        let path = endPoint.getPath()
        // create the full url from the above variables
        let fullURL = URL(string: baseURL.appending("\(path)?\(stringParams)"))!
        //MARK: try changing this to .append
        // build the request
        var request = URLRequest(url: fullURL)
        request.httpMethod = endPoint.getHTTPMethod()
        request.allHTTPHeaderFields = endPoint.getHeaders(token: token)
        
        return request
    }
    
    
    
    func getPosts(_ completion: @escaping (Result<[Post]>) -> Void) {
        // our API query
        let postsRequest = makeRequest(for: .posts)

        
        
        let task = urlSession.dataTask(with: postsRequest) { data, response, error in
            // error check/handling
            if let error = error {
                return completion(Result.failure(error))
            }
            
            // make sure we get back data
            guard let data = data else {
                return completion(Result.failure(EndPointError.noData))
            }
            // Decode the API response into our PostList object that we can use/interact with
            guard let result = try? JSONDecoder().decode(PostList.self, from: data) else {
                return completion(Result.failure(EndPointError.couldNotParse))
            }
            let posts = result.posts
            
            DispatchQueue.main.sync {
                completion(Result.success(posts))
            }
        }
        task.resume()
        
    }
    
    
    
    func getComments(_ postId: Int, completion: @escaping (Result<[Comment]>) -> Void) {
      let commentsRequest = makeRequest(for: .comments(postId: postId))
      let task = urlSession.dataTask(with: commentsRequest) { data, response, error in
        // Check for errors
        if let error = error {
          return completion(Result.failure(error))
        }

        // Check to see if there is any data that was retrieved.
        guard let data = data else {
          return completion(Result.failure(EndPointError.noData))
        }

        // Attempt to decode the comment data.
        guard let result = try? JSONDecoder().decode(CommentApiResponse.self, from: data) else {
          return completion(Result.failure(EndPointError.couldNotParse))
        }

        // Return the result with the completion handler.
        DispatchQueue.main.async {
          completion(Result.success(result.comments))
        }
      }

      task.resume()
    }
    
    
    
    enum EndPoints {
        case posts
        case comments(postId: Int)
        
        
        func getPath() -> String {
            
            switch self {
            case .posts:
                return "posts/all"
            case .comments:
                return "comments"
            }
        }
        
        
        func getHTTPMethod() -> String {
            return "GET"
        }
        
        
        func getHeaders(token: String) -> [String: String] {
            return [
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)",
                "Host": "api.producthunt.com"
            ]
        }
        
        
        func getParams() -> [String: String] {
            switch self {
            case .posts:
                return [
                    "sort_by": "votes_count",
                    "order": "desc",
                    "per_page": "20",
                    
                    "search[featured]": "true"
                ]
                
            case let .comments(postId):
                return [
                    "sort_by": "votes",
                    "order": "asc",
                    "per_page": "20",
                    
                    "search[post_id]": "\(postId)"
                ]
            }
        }
        
        
        func paramsToString() -> String {
            let parameterArray = getParams().map { key, value in
                return "\(key)=\(value)"
            }
            
            return parameterArray.joined(separator: "&")
        }
        
        
    }
    
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    enum EndPointError: Error {
        case couldNotParse
        case noData
    }
    
    
    
}


