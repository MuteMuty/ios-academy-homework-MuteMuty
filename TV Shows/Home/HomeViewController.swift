//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum on 20.07.2022..
//

import UIKit
import MBProgressHUD

final class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var user: User?
    var authInfo: AuthInfo?
    private var shows: [Show] = []
    private var service: Service = Service()
    private var allPages: Int = 1
    private var currentPage: Int = 1
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        MBProgressHUD.showAdded(to: view, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.dataSource = self
        tableView.delegate = self
        
        getShows(page: currentPage)
    }
    
    // MARK: - Actions
    
    
    
    // MARK: - Utility methods
    
    private func getShows(page: Int) {
        service.getShows(page: page) {  [weak self] dataResponse in
            guard let self = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            
            switch dataResponse.result {
            case .success(let showResponse):
                self.allPages = showResponse.meta.pagination.pages
                self.currentPage = showResponse.meta.pagination.page
                self.shows.append(contentsOf: showResponse.shows)
                self.tableView.reloadData()
                print("success!")
            case .failure:
                print("failure")
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ShowTableViewCell", for: indexPath
        ) as! ShowTableViewCell
        cell.thumbnailImageView.image = UIImage(named: "ic-profile.pdf")
        cell.titleLabel.text = shows[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if currentPage < allPages && indexPath.row == shows.count - 1 {
            currentPage += 1
            getShows(page: currentPage)
        }
    }
}

// MARK: - Private

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let show = shows[indexPath.row]
        
        print(show)
    }
}
