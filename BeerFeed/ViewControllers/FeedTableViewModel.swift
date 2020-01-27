//
//  FeedTableViewModel.swift
//  BeerFeed
//
//  Created by Alice Fox on 1/27/20.
//  Copyright © 2020 Alice Fox. All rights reserved.
//

import Foundation
import Alamofire

protocol FeedTableViewModelDelegate: class {
    func updateDataForIndexRange(_ range: Range<Int>?)
    func showAlertWithErrorText(_ errorText: String)
}

class FeedTableViewModel {
    
    weak var feedTableVC: FeedTableViewModelDelegate?
    
    private var networkingManager = NetworkingManager()
    var beerData = [Beer]()
        
    func loadMoreBeer() {
    
        let page = beerData.count / networkingManager.itemsPerPageCount + 1
        
        networkingManager.loadData(page: page) { [weak self] (response) in
            guard let strongSelf = self else {return}
            switch response {
            case let .success(result):
                var updateRange: Range<Int>?
                
                if strongSelf.beerData.isEmpty {
                    strongSelf.beerData = result
                } else {
                    let startIndex = strongSelf.beerData.count
                    strongSelf.beerData.append(contentsOf:result)
                    let endIndex = strongSelf.beerData.count
                    updateRange = (startIndex..<endIndex)
                }
                
                strongSelf.feedTableVC?.updateDataForIndexRange(updateRange)
                break
            case let .failure(error):
                strongSelf.feedTableVC?.showAlertWithErrorText(error.localizedDescription)
            }
        }
    }
}
