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
    
    // MARK: - Public Properties
    
    var user: User?
    var authInfo: AuthInfo?
    
    // MARK: - Private Properties
    
    private var shows: [Show] = []
    private var service: Service = Service()
    private var allPages: Int = 1
    private var currentPage: Int = 1
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        setUpView()
    }
    
    // MARK: - Utility methods
    
    private func setUpView() {
        MBProgressHUD.showAdded(to: view, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.dataSource = self
        tableView.delegate = self
        getShows(page: currentPage)
    }
    
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
            withIdentifier: String(describing: ShowTableViewCell.self), for: indexPath
        ) as! ShowTableViewCell
        cell.setup(with: ShowItem(showTitle: shows[indexPath.row].title, image: UIImage(named: "ic-profile.pdf")))
        
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
        
        let storyboard = UIStoryboard(name: "ShowDetails", bundle: .main)
        let showDetailsViewController = storyboard.instantiateViewController(
            withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
        showDetailsViewController.show = show
        showDetailsViewController.user = user
        navigationController?.pushViewController(showDetailsViewController, animated: true)
        
        print(show)
    }
}
