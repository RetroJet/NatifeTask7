//
//  FilmsListInfo.swift
//  NatifeTask7
//
//  Created by Nazar on 24.04.2026.
//

struct FilmsPage {
    let page: Int
    let totalPages: Int
    let films: [FilmsListInfo]
    
    struct FilmsListInfo {
        let id: Int
        let poster: String?
        let title: String
        let genreIds: [Int]
        let rating: Double
        let date: String
    }
}
