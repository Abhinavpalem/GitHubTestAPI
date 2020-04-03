//
//  UserEmails.swift
//  GitHubMarketPlace
//
//  Created by Abhinav reddy Palem on 4/2/20.
//  Copyright © 2020 Abhinav reddy Palem. All rights reserved.
//

import Foundation

struct UserEmails: Codable {
    var email: String
    var verified: Bool
    var primary: Bool
    var visibility: String
}
