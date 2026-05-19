//
//  FilmsListViewStateFactory.swift
//  NatifeTask7
//
//  Created by Nazar on 30.04.2026.
//

import Foundation

struct FilmsListViewStateFactoryInput {
    let films: [FilmsPage.FilmsListInfo]
    let genres: [GenresInfo]
}

protocol FilmsListViewStateFactoryProtocol {
    func make(_ input: FilmsListViewStateFactoryInput) -> [FilmsListViewState.Item]
}

struct FilmsListViewStateFactory: FilmsListViewStateFactoryProtocol {
    func make(_ input: FilmsListViewStateFactoryInput) -> [FilmsListViewState.Item] {
        let genreMap = Dictionary(uniqueKeysWithValues: input.genres.map { ($0.id, $0.name) })
        
        let items = input.films.map { film in
            let poster = film.poster.flatMap { URL(string: Constant.Image.posterBaseURL + $0) }
            let rating = String(format: "%.1f", film.rating)
            let title = film.date.isEmpty ? film.title : film.title + ", " + String(film.date.prefix(4))
            let genre = film.genreIds
                .compactMap { genreMap[$0] }
                .prefix(3)
                .joined(separator: ", ")
            
            return FilmsListViewState.Item(
                id: film.id,
                poster: poster,
                title: title,
                genre: genre,
                rating: rating
            )
        }
        
        return items
    }
}

private extension FilmsListViewStateFactory {
    enum Constant {
        enum Image {
            static let posterBaseURL = "https://image.tmdb.org/t/p/w500"
        }
    }
}
