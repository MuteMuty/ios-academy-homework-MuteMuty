//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum on 27.07.2022..
//

import UIKit
import MBProgressHUD

class ShowDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var showTitle: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public Properties
    
    var show: Show?
    var user: User?
    var reviews: [Review] = []
    
    // MARK: - Private Properties
    
    private var service: Service = Service()
    private var allPages: Int = 1
    private var currentPage: Int = 1
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        MBProgressHUD.showAdded(to: view, animated: true)
        
        tableView.dataSource = self
        showTitle.title = show?.title
        getShowId(page: currentPage, id: show!.id)
        
        
        tableView.register(UINib(nibName: "ShowInfoCell", bundle: nil), forCellReuseIdentifier: String(describing: ShowInfoCell.self))
        tableView.register(UINib(nibName: "ShowReviewCell", bundle: nil), forCellReuseIdentifier: String(describing: ShowReviewCell.self))
    }
    
    // MARK: - Actions
    
    @IBAction func writeReviewButtonClicked() {
        let storyboard = UIStoryboard(name: "Home", bundle: .main)
        let writeAReviewViewController = storyboard.instantiateViewController(
            withIdentifier: "HomeViewController")
            as! HomeViewController
        
        let navigationController = UINavigationController(rootViewController: writeAReviewViewController)
        self.present(navigationController, animated: true)
    }
    
    // MARK: - Utility methods
    
    private func getShowId(page: Int, id: String) {
        service.getShowId(page: page, id: id) {  [weak self] dataResponse in
            guard let self = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            
            switch dataResponse.result {
            case .success(let reviewResponse):
                self.allPages = reviewResponse.meta.pagination.pages
                self.currentPage = reviewResponse.meta.pagination.page
                self.reviews.append(contentsOf: reviewResponse.reviews)
                self.tableView.reloadData()
                print(self.reviews.count)
                print("success!")
            case .failure:
                print("failure")
            }
        }
    }
    
}

// MARK: - UITableViewDataSource

extension ShowDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let infoCell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ShowInfoCell.self), for: indexPath
            ) as! ShowInfoCell
            
            infoCell.setup(with: ShowInfoItem(image: UIImage(named: "ic-profile.pdf"), showDescription: (show?.description)!, show: show!))
            
            return infoCell
        } else {
            let reviewCell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ShowReviewCell.self), for: indexPath
            ) as! ShowReviewCell
            
            let review = reviews[indexPath.row - 1]
            reviewCell.setup(with: ShowReviewItem(profileImage: UIImage(named: "ic-profile.pdf"), email: review.user.email, review: review.comment))
            
            if currentPage < allPages && indexPath.row == reviews.count - 1 {
                currentPage += 1
                getShowId(page: currentPage, id: show!.id)
            }
            return reviewCell
        }
    }
}
