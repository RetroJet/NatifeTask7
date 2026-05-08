//
//  FilmDetailViewState.swift
//  NatifeTask7
//
//  Created by Nazar on 05.05.2026.
//

import Foundation

struct FilmDetailViewState: Hashable {
    let item: FilmDetailItemViewState
}

struct FilmDetailItemViewState: Hashable {
    let poster: URL?
    let title: String
    let country: [String]
    let date: String
    let genres: String
    let trailer: String?
    let rating: String
    let description: String
}
