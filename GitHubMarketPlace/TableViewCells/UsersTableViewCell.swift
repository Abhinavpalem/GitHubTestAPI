//
//  UsersTableViewCell.swift
//  GitHubMarketPlace
//
//  Created by Abhinav reddy Palem on 4/2/20.
//  Copyright © 2020 Abhinav reddy Palem. All rights reserved.
//

import UIKit
import AlamofireImage

class UsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var reposLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(user: Users) {
        userLbl.text = user.login
        
        if let repos = Utility.shared.cache[user.login!] {
            self.reposLbl.text = "Repos: \(repos)"
        }else {
            fetchRepos(user: user.login!)
        }
        
        if let urlStr = user.avatar_url, let url = URL(string: urlStr) {
            
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: profileImgView.frame.size,
                radius: (profileImgView.frame.width / 2)
            )
            
            profileImgView.af_setImage(withURL: url, placeholderImage: UIImage(named: "profile"), filter: filter, imageTransition: .crossDissolve(0.2))
        }
    }
    
    func fetchRepos(user name: String) {
        
        NetworkManager.shared.getUserRepos(search: name) { (response, error) in
            guard let model = response else {
                return
            }
            
            Utility.shared.cache[name] = model.count
            
            DispatchQueue.main.async {
                self.reposLbl.text = "Repos: \(model.count)"
            }
            
        }
    }
}
