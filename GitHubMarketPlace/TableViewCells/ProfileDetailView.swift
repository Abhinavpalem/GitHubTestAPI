//
//  ProfileDetailView.swift
//  GitHubMarketPlace
//
//  Created by Abhinav reddy Palem on 4/2/20.
//  Copyright © 2020 Abhinav reddy Palem. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileDetailView: UIView {
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var joinDate: UILabel!
    @IBOutlet weak var followersLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(user: Users) {
        userLbl.text = user.login
        
        if let urlStr = user.avatar_url, let url = URL(string: urlStr) {
            
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: profileImgView.frame.size,
                radius: (profileImgView.frame.width / 2)
            )
            
            profileImgView.af_setImage(withURL: url, placeholderImage: UIImage(named: "profile"), filter: filter, imageTransition: .crossDissolve(0.2))
        }
    }
    
    func configure(followers: Int) {
        followersLbl.text = "\(followers) Followers"
    }
}
