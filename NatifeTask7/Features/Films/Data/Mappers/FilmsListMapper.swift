//
//  FilmsListMapper.swift
//  NatifeTask7
//
//  Created by Nazar on 24.04.2026.
//

struct FilmsListMapper {
    static func toDomain(_ response: FilmsListResponse) -> FilmsPage {
        FilmsPage(
            page: response.page,
            totalPages: response.totalPages,
            films: response.results.map(toDomain)
        )
    }
    
    nonisolated static func toDomain(_ dto: FilmsListDTO) -> FilmsListInfo {
        FilmsListInfo(
            id: dto.id,
            poster: dto.posterPath,
            title: dto.title,
            genreIds: dto.genreIds,
            rating: dto.voteAverage,
            date: dto.releaseDate
        )
    }
}
