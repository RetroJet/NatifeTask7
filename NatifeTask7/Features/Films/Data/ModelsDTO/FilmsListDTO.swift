//
//  FilmsListDTO.swift
//  NatifeTask7
//
//  Created by Nazar on 23.04.2026.
//

struct FilmsListResponse: Decodable {
    let page: Int
    let totalPages: Int
    let results: [FilmsListDTO]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case results
    }
    
    struct FilmsListDTO: Decodable {
        let id: Int
        let posterPath: String?
        let title: String
        let genreIds: [Int]
        let voteAverage: Double
        let releaseDate: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case posterPath = "poster_path"
            case title
            case genreIds = "genre_ids"
            case voteAverage = "vote_average"
            case releaseDate = "release_date"
        }
    }
}
