//
//  NetworkingManager.swift
//  BeerFeed
//
//  Created by Alice Fox on 1/26/20.
//  Copyright © 2020 Alice Fox. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingManager {
    
    enum ParameterName: String {
        case pageIndex = "page"
        case perPageCount = "per_page"
    }
    
    private let session = Alamofire.Session()
    
    let itemsPerPageCount = 25
    private let beerUrl = "https://api.punkapi.com/v2/beers.."
    
    private func createPageParameters(page: Int) -> Dictionary<String, Any> {
        return [ParameterName.pageIndex.rawValue : page,
                ParameterName.perPageCount.rawValue : itemsPerPageCount]
    }
    
    func loadData(page: Int, callback: @escaping (Result<[Beer], AFError>) -> Void) {
        let request = session.request(beerUrl,
                                      parameters: createPageParameters(page: page))
        request.responseDecodable(of: [Beer].self) { response in
            callback(response.result)
        }
    }
}
