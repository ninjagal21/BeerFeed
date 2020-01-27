//
//  FeedTableViewController.swift
//  BeerFeed
//
//  Created by Alice Fox on 1/26/20.
//  Copyright © 2020 Alice Fox. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController, UITableViewDataSourcePrefetching, FeedTableViewModelDelegate {
    
    private let estimatedRowHeight: CGFloat = 100.0
    private let sectionNumber = 0
    
    private let viewModel = FeedTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.feedTableVC = self
        
        viewModel.loadMoreBeer()
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.tableFooterView = UIView(frame: .zero)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.beerData.count + 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row >= viewModel.beerData.count {
            return tableView.dequeueReusableCell(withIdentifier: "loadingCellIdentifier", for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! FeedTableViewCell
        let beer = viewModel.beerData[indexPath.row]
        cell.setup(imageUrl: URL(string: beer.imageUrl),
                   nameText: beer.name,
                   tagText: beer.tagline,
                   descriptionText: beer.description);
        return cell
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastIndex = viewModel.beerData.count
        if indexPaths.contains(IndexPath(row: lastIndex, section: sectionNumber)) {
            viewModel.loadMoreBeer()
        }
    }
    
    // MARK: - View Model Delegate
    
    func updateDataForIndexRange(_ range: Range<Int>?) {
        if let range = range {
            let indexPathArray = range.map { IndexPath(row: $0, section: sectionNumber)}
            tableView.insertRows(at: indexPathArray, with: .automatic)
        } else {
            tableView.reloadData()
        }
    }
    
    func showAlertWithErrorText(_ errorText: String) {
        let alert = UIAlertController(title: "Error",
                                      message: errorText,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Retry",
                                      style: UIAlertAction.Style.default,
                                      handler: {[weak self] action in
                                        self?.viewModel.loadMoreBeer()
        }))
        present(alert, animated: true, completion: nil)
    }
}
