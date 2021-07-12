//
//  URLTest.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/09.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

struct Todo: Codable {
    let userid: Int
    let id: Int
    let title: String
    let completed: Bool
    
    enum CodingKeys: String, CodingKey {
        case userid = "userId"
        case id
        case title
        case completed
    }
}

class APIManager {

    func fetchMovies() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {data, res, error in
            guard let data = data else { return }
            let decode = try? JSONDecoder().decode([Todo].self, from: data)
            print(decode!)
        }.resume()
        
    }
}
