//
//  FilmDetailViewStateFactory.swift
//  NatifeTask7
//
//  Created by Nazar on 06.05.2026.
//

import Foundation

struct FilmDetailViewStateFactoryInput {
    let film: FilmDetailInfo
    let trailer: TrailerInfo?
}

protocol FilmDetailViewStateFactoryProtocol {
    func make(_ input: FilmDetailViewStateFactoryInput) -> FilmDetailViewState.Item
}

struct FilmDetailViewStateFactory: FilmDetailViewStateFactoryProtocol {
    func make(_ input: FilmDetailViewStateFactoryInput) -> FilmDetailViewState.Item {
        let poster = input.film.poster.flatMap { URL(string: Constant.Image.backdropBaseURL + $0) }
        let rating = String(format: "%.1f", input.film.rating)
        let date = String(input.film.date.prefix(4))
        let item = FilmDetailViewState.Item(
            poster: poster,
            title: input.film.title,
            country: input.film.country,
            date: date,
            genres: input.film.genres.joined(separator: ", "),
            trailer: input.trailer?.key,
            rating: rating,
            description: input.film.description
        )
        
        return item
    }
}

private extension FilmDetailViewStateFactory {
    enum Constant {
        enum Image {
            static let backdropBaseURL = "https://image.tmdb.org/t/p/w1280"
        }
    }
}
