//
//  FilmDetailViewState.swift
//  NatifeTask7
//
//  Created by Nazar on 05.05.2026.
//

import Foundation

struct FilmDetailViewState {
    enum Kind {
        case loading
        case content(Item)
        case error(String)
    }
    
    struct Item: Hashable {
        let poster: URL?
        let title: String
        let country: [String]
        let date: String
        let genres: String
        let trailer: String?
        let rating: String
        let description: String
    }
    
    let title: String
    let kind: Kind
}
