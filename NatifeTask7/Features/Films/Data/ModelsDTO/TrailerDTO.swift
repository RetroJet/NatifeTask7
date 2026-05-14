//
//  TrailerDTO.swift
//  NatifeTask7
//
//  Created by Nazar on 05.05.2026.
//

struct TrailerResponse: Decodable {
    let results: [TrailerDTO]
    
    struct TrailerDTO: Decodable {
        let key: String
        let site: String
        let type: String
    }
}
