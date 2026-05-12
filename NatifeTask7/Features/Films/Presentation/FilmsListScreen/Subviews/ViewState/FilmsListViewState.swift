//
//  FilmsListViewState.swift
//  NatifeTask7
//
//  Created by Nazar on 30.04.2026.
//

import Foundation

nonisolated struct FilmsListViewState {
    enum Kind {
        case loading
        case content([Item])
        case error(String)
    }
    
    nonisolated struct Item: Hashable {
        let id: Int
        let poster: URL?
        let title: String
        let genre: String
        let rating: String
        let date: String
    }
    
    let kind: Kind
    let animated: Bool
}
