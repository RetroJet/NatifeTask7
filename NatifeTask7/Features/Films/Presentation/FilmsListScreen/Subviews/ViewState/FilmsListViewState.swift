//
//  FilmsListViewState.swift
//  NatifeTask7
//
//  Created by Nazar on 30.04.2026.
//

import Foundation

nonisolated struct FilmsListViewState: Hashable {
    let items: [FilmsListItemViewState]
}

nonisolated struct FilmsListItemViewState: Hashable {
    let id: Int
    let poster: URL?
    let title: String
    let genre: String
    let rating: String
    let date: String
}
