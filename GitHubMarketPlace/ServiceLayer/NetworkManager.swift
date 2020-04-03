//
//  NetworkManager.swift
//  GitHubMarketPlace
//
//  Created by Abhinav reddy Palem on 4/2/20.
//  Copyright © 2020 Abhinav reddy Palem. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    enum URLPath: String {
        case users = "/search/users?q="
        case repos = "/users/%@/repos"
    }
    
    let baseURL = "https://api.github.com"
    
    static let shared: NetworkManager = NetworkManager()
    
    private init() {
        
    }
    
    func getSearchUsers(search name: String, handler: @escaping (_ response: UsersResponseModel?, _ error: Error?) -> Void) {
        let urlString = "\(baseURL)\(URLPath.users.rawValue)"
        print("\(#function): \(urlString)")
        
        Alamofire.request(urlString, method: .get, parameters: ["q": name])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { (response) in
                switch response.result {
                case .success(let value):
                    do {
                        let model = try JSONDecoder().decode(UsersResponseModel.self, from: value)
                        handler(model, nil)
                    }catch {
                        
                    }
                case .failure(let error):
                    print(error)
                    handler(nil, error)
                }
                
        }
    }
    
    func getUserRepos(search name: String, handler: @escaping (_ response: [RepositoryResponseModel]?, _ error: Error?) -> Void) {
        let urlString = "\(baseURL)/\("users")/\(name)/\("repos")"
        print("\(#function): \(urlString)")
        
        Alamofire.request(urlString, method: .get, parameters: ["q": name])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { (response) in
                switch response.result {
                case .success(let value):
                    do {
                        let model = try JSONDecoder().decode([RepositoryResponseModel].self, from: value)
                        handler(model, nil)
                    }catch {
                        
                    }
                case .failure(let error):
                    print(error)
                    handler(nil, error)
                }
                
        }
    }
    
    func getUserFollow(search name: String, path: String, handler: @escaping (_ followers: Int?, _ error: Error?) -> Void) {
        let urlString = "\(baseURL)/\("users")/\(name)/\(path)"
        print("\(#function): \(urlString)")
        
        Alamofire.request(urlString, method: .get, parameters: ["q": name])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { (response) in
                switch response.result {
                case .success(let value):
                    do {
                        let model = try JSONSerialization.jsonObject(with: value, options: .mutableContainers) as? [Any]
                        
                        handler(model?.count, nil)
                    }catch {
                        
                    }
                case .failure(let error):
                    print(error)
                    handler(nil, error)
                }
        }
    }
    
    func getStargazers(path: String, handler: @escaping (_ response: [StargazerModel]?, _ error: Error?) -> Void) {
        print("\(#function): \(path)")
        Alamofire.request(path, method: .get, parameters: [:])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { (response) in
                switch response.result {
                case .success(let value):
                    do {
                        let model = try JSONSerialization.jsonObject(with: value, options: .mutableContainers) as? [StargazerModel]
                        handler(model, nil)
                    }catch {
                        
                    }
                case .failure(let error):
                    print(error)
                    handler(nil, error)
                }
        }
    }
}
