//
//  APIService.swift
//  uikit-dca-calculator
//
//  Created by joe on 2023/12/01.
//

import Foundation
import Combine

struct APIService {
    var API_KEY: String {
        return keys.randomElement() ?? ""
    }
    
    let keys = ["WS58F5EN3448FX1C", "HXMUNDJIX81H2UDJ", "6DUG1TOBABY1SOPG", "N483IC64XUG8M4VQ"]
    
    func fetchSymbolsPublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"
        let url = URL(string: urlString)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
