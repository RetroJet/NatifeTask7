//
//  FilmDetailDTO.swift
//  NatifeTask7
//
//  Created by Nazar on 05.05.2026.
//

struct FilmDetailDTO: Decodable {
    let id: Int
    let backdropPath: String?
    let title: String
    let originCountry: [String]
    let releaseDate: String
    let genres: [GenresResponse.GenresDTO]
    let voteAverage: Double
    let overview: String
        
    enum CodingKeys: String, CodingKey {
        case id
        case backdropPath = "backdrop_path"
        case title
        case originCountry = "origin_country"
        case releaseDate = "release_date"
        case genres
        case voteAverage = "vote_average"
        case overview
    }
}
