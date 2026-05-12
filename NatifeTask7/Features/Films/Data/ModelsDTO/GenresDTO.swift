//
//  GenresDTO.swift
//  NatifeTask7
//
//  Created by Nazar on 01.05.2026.
//

struct GenresResponse: Decodable {
    let genres: [GenresDTO]
    
    struct GenresDTO: Decodable {
        let id: Int
        let name: String
    }
}
