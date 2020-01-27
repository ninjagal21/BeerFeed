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
    let session = Alamofire.Session()
    
    var pageNumber = 1
    let itemsPerPage = 25
    let beerUrl = "https://api.punkapi.com/v2/beers"
    var parameters: [String: Any] {
        return ["page" : pageNumber, "per_page" : itemsPerPage]
    }
    
    func loadData(for index: Int? = nil , callback: @escaping ([Beer]) -> Void) {
        
        if (index != nil) {pageNumber = index! / itemsPerPage}
        
        let request = session.request(beerUrl, parameters: parameters)
        request.responseDecodable(of: [Beer].self) { response in
          switch response.result {
          case let .success(result): //infinite scroll
            callback(result)
            break;
          case let .failure(error): //paging
            break;
          }
        }
    }
}
