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
        
    let estimatedRowHeight: CGFloat = 100.0
    let sectionNumber = 0
    
    let networkingManager = NetworkingManager()
    var beerData = [Beer]()
    
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
        
        isLoading = true
        networkingManager.loadData { (data) in
            self.beerData = data
            self.tableView.reloadData()
            self.isLoading = false
        }
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

        
        cell.descriptionLabel.text = beer.description
        cell.nameLabel.text = beer.name
        cell.taglineLabel.text = beer.tagline
        
        let filter = AspectScaledToFitSizeFilter(size: CGSize(width: cell.postImageView.frame.width, height: cell.postImageView.frame.height))
        cell.postImageView?.af_setImage(withURL: URL(string: beer.imageUrl)!,
                                    placeholderImage: UIImage(named: "placeholderImage"),
                                    filter: filter)
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(IndexPath(row: beerData.count, section: sectionNumber)) {
            networkingManager.loadData(for: beerData.count, callback: { (newBeerData) in
                self.beerData.append(contentsOf:newBeerData)
                let startIndex = tableView.numberOfRows(inSection: self.sectionNumber) - 1
                let endIndex = self.beerData.count
                let indexPathArray = (startIndex..<endIndex).map { IndexPath(row: $0, section: self.sectionNumber)}
                tableView.insertRows(at: indexPathArray, with: .automatic)
            })
        }
    }
}
