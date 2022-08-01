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
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Public Properties
    
    var user: User?
    
    // MARK: - Private Properties
    
    private var shows: [Show] = []
    private var service: Service = Service()
    private var allPages: Int = 1
    private var currentPage: Int = 1
    private var notificationToken: NSObjectProtocol?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        setUpView()
    }
    
    // MARK: - Utility methods
    
    private func setUpView() {
        MBProgressHUD.showAdded(to: view, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let profileDetailsItem = UIBarButtonItem(
          image: UIImage(named: "ic-profile"),
          style: .plain,
          target: self,
          action: #selector(profileDetailsActionHandler)
        )
        profileDetailsItem.tintColor = #colorLiteral(red: 0.3215686275, green: 0.2117647059, blue: 0.5490196078, alpha: 1)
        navigationItem.rightBarButtonItem = profileDetailsItem
        
        tableView.dataSource = self
        tableView.delegate = self
        getUser()
        getShows(page: currentPage)
        notification()
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
            case .failure:
                print("failure")
            }
        }
    }
    
    func getUser() {
        service.getUser {  [weak self] dataResponse in
            guard let self = self else { return }
            
            switch dataResponse.result {
            case .success(let userResponse):
                self.user = userResponse.user
            case .failure:
                print("failure")
            }
        }
    }
    
    private func notification() {
        notificationToken = NotificationCenter
            .default
            .addObserver(
                forName: Notification.Name(rawValue: "logout"),
                object: nil,
                queue: nil
            ) {
                [weak self] notification in
                guard let self = self else { return }
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(
                    withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.setViewControllers([loginViewController], animated: true)
            }
    }
    
    @objc private func profileDetailsActionHandler() {
        let storyboard = UIStoryboard(name: "ProfileDetails", bundle: .main)
        let profileDetailsViewController = storyboard.instantiateViewController(
            withIdentifier: "ProfileDetailsViewController")
            as! ProfileDetailsViewController
        
        profileDetailsViewController.user = user
        let navigationController = UINavigationController(rootViewController: profileDetailsViewController)
        present(navigationController, animated: true)
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
        
        
        let show = shows[indexPath.row]
        cell.setup(with: ShowItem(show: show))
        
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
        navigationController?.pushViewController(showDetailsViewController, animated: true)
    }
}
