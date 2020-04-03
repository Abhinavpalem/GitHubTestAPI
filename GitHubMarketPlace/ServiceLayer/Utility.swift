//
//  Utility.swift
//  GitHubMarketPlace
//
//  Created by Abhinav reddy Palem on 4/2/20.
//  Copyright © 2020 Abhinav reddy Palem. All rights reserved.
//

import Foundation

class Utility {
    static let shared: Utility = Utility()
    
    private init() { }
    
    var cache: [String: Int] = [String: Int]()
    
}
