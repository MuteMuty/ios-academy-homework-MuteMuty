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
    
    @IBOutlet private weak var showTitle: UINavigationItem!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Public Properties
    
    var show: Show?
    var reviews: [Review] = []
    
    // MARK: - Private Properties
    
    private var service: Service = Service()
    private var allPages: Int = 1
    private var currentPage: Int = 1
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        setupTable()
    }
    
    // MARK: - Actions
    
    @IBAction func writeReviewButtonClicked() {
        let storyboard = UIStoryboard(name: "WriteReview", bundle: .main)
        let writeReviewViewController = storyboard.instantiateViewController(
            withIdentifier: "WriteReviewViewController")
            as! WriteReviewViewController
        
        guard let show = show else { return }
        writeReviewViewController.show = show
        writeReviewViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: writeReviewViewController)
        present(navigationController, animated: true)
    }
    
    // MARK: - Utility methods
    
    private func setupTable() {
        MBProgressHUD.showAdded(to: view, animated: true)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.3215686275, green: 0.2117647059, blue: 0.5490196078, alpha: 1)
        guard let show = show else { return }
        
        tableView.dataSource = self
        showTitle.title = show.title
        
        displayShow(id: show.id)
        getShowId(page: currentPage, id: show.id)
        
        tableView.register(UINib(nibName: "ShowInfoCell", bundle: nil), forCellReuseIdentifier: String(describing: ShowInfoCell.self))
        tableView.register(UINib(nibName: "ShowReviewCell", bundle: nil), forCellReuseIdentifier: String(describing: ShowReviewCell.self))
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
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
                self.tableView.refreshControl?.endRefreshing()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func displayShow(id: String) {
        service.displayShow(id: id) { [weak self] dataResponse in
            guard let self = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            
            switch dataResponse.result {
            case .success(let reviewResponse):
                self.show = reviewResponse.show
                self.tableView.reloadData()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    @objc private func pullToRefresh() {
        reloadData()
    }
    
}

// MARK: - UITableViewDataSource

extension ShowDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .infoCell:
            return 1
        case .reviewCell:
            return reviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let show = show else { return UITableViewCell() }
        switch sections[indexPath.section] {
        case .infoCell:
            let infoCell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ShowInfoCell.self),
                for: indexPath
            ) as! ShowInfoCell

            infoCell.setup(with: ShowInfoItem(show: show))

            return infoCell
        case .reviewCell:
            let reviewCell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ShowReviewCell.self),
                for: indexPath
            ) as! ShowReviewCell

            let review = reviews[indexPath.row]
            reviewCell.setup(with: ShowReviewItem(review: review))

            if currentPage < allPages && indexPath.row + 1 == reviews.count {
                currentPage += 1
                getShowId(page: currentPage, id: show.id)
            }

            return reviewCell
        }
    }
}

enum Section {
    case infoCell
    case reviewCell
}

private var sections: [Section] = [
    .infoCell,
    .reviewCell
]

extension ShowDetailsViewController: ReloadData {
    func reloadData() {
        reviews = []
        currentPage = 1
        guard let show = show else { return }
        
        displayShow(id: show.id)
        getShowId(page: currentPage, id: show.id)
    }
}
