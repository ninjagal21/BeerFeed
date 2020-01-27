//
//  FeedTableViewController.swift
//  BeerFeed
//
//  Created by Alice Fox on 1/26/20.
//  Copyright © 2020 Alice Fox. All rights reserved.
//

import UIKit
import AlamofireImage

class FeedTableViewController: UITableViewController, UITableViewDataSourcePrefetching {
        
    private let estimatedRowHeight: CGFloat = 100.0
    private let sectionNumber = 0
    private let initialPageIndex = 1
    
    private let networkingManager = NetworkingManager()
    private var beerData = [Beer]()
    
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        isLoading = true
        loadPage(initialPageIndex)
    }
    
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.tableFooterView = UIView(frame: .zero)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerData.count + 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row >= beerData.count {
            return tableView.dequeueReusableCell(withIdentifier: "loadingCellIdentifier", for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! FeedTableViewCell
        let beer = beerData[indexPath.row]
        cell.setup(imageUrl: URL(string: beer.imageUrl),
                   nameText: beer.name,
                   tagText: beer.tagline,
                   descriptionText: beer.description);
        return cell
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(IndexPath(row: beerData.count, section: sectionNumber)) {
            let pageIndexToLoad = beerData.count / networkingManager.itemsPerPageCount + 1
            loadPage(pageIndexToLoad)
        }
    }
    
    func loadPage(_ page: Int) {
        networkingManager.loadData(page: page) { [weak self] (response) in
            
            guard let strongSelf = self else {return}
            
            switch response {
            case let .success(result):
                if page == strongSelf.initialPageIndex {
                    strongSelf.beerData = result
                    strongSelf.tableView.reloadData()
                    strongSelf.isLoading = false
                } else {
                    let startIndex = strongSelf.beerData.count + 1
                    strongSelf.beerData.append(contentsOf:result)
                    let endIndex = strongSelf.beerData.count
                    let indexPathArray = (startIndex..<endIndex).map { IndexPath(row: $0, section: strongSelf.sectionNumber)}
                    strongSelf.tableView.insertRows(at: indexPathArray, with: .automatic)
                }
                break
            case let .failure(error):
                strongSelf.showAlert(error, currentPageLoading: page)
                break
            }
        }
    }

    func showAlert(_ error: Error, currentPageLoading: Int) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Retry",
                                      style: UIAlertAction.Style.default,
                                      handler: {[weak self] action in
                                        self?.loadPage(currentPageLoading)
        }))
        present(alert, animated: true, completion: nil)
    }
}
