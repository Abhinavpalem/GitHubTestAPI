//
//  DetailViewController.swift
//  GitHubMarketPlace
//
//  Created by Abhinav reddy Palem on 4/2/20.
//  Copyright © 2020 Abhinav reddy Palem. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var profileView: ProfileDetailView!
    
    let reposCell = "reposCell"
    var searchActive = false
    
    var repos: [RepositoryResponseModel] = [RepositoryResponseModel]()
    var user: Users!
    var filtered: [RepositoryResponseModel] = [RepositoryResponseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configurationView()
    }
    
    // MARK:- custom methods
    func configurationView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(ReposTableViewCell.self, forCellReuseIdentifier: reposCell)
        tableView.register(UINib(nibName: "ReposTableViewCell", bundle: nil), forCellReuseIdentifier: reposCell)
        profileView.configure(user: user)
        fetchRepos()
        fetchFollowers()
        fetchFollowings()
    }
    
    func fetchFollowers() {
        NetworkManager.shared.getUserFollow(search: user.login!, path: "followers") { (response, error) in
            guard let followers = response else {
                return
            }
            DispatchQueue.main.async {
                self.profileView.configure(followers: followers)
            }
        }
    }
    
    func fetchFollowings() {
        NetworkManager.shared.getUserFollow(search: user.login!, path: "following") { (response, error) in
            guard let following = response else {
                return
            }
            DispatchQueue.main.async {
                self.profileView.followingLbl.text = "\(following) Followings"
            }
        }
    }
    
    func fetchRepos() {
        
        NetworkManager.shared.getUserRepos(search: user.login!) { (response, error) in
            guard let model = response else {
                return
            }
            self.repos = model
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    func fetchStargazers(repo: RepositoryResponseModel, indexPath: IndexPath) {
        guard let url = repo.stargazers_url else { return }
        NetworkManager.shared.getStargazers(path: url) { (response, error) in
            guard let model = response else { return }
            repo.starsCount = model.count
            
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ?  filtered.count : repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: reposCell, for: indexPath) as! ReposTableViewCell
        let repo = searchActive ? filtered[indexPath.row] : repos[indexPath.row]
        if repo.starsCount == nil {
            fetchStargazers(repo: repo, indexPath: indexPath)
        }
        cell.configure(repo: searchActive ? filtered[indexPath.row] : repos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DetailViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filtered = repos.filter { (model) -> Bool in
            if let str = model.name?.lowercased() {
                return str.contains(searchText.lowercased())
            }
            return false
        }
        if(searchText.count > 0){
            searchActive = true;
        } else {
            searchActive = false;
        }
        self.filtered = filtered
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
