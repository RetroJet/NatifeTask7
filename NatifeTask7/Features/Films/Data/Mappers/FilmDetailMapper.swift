//
//  FilmDetailMapper.swift
//  NatifeTask7
//
//  Created by Nazar on 05.05.2026.
//

struct FilmDetailMapper {
    static func toDomain(_ dto: FilmDetailDTO) -> FilmDetailInfo {
        FilmDetailInfo(
            id: dto.id,
            poster: dto.backdropPath,
            title: dto.title,
            country: dto.originCountry,
            date: dto.releaseDate,
            genres: dto.genres.map { $0.name },
            rating: dto.voteAverage,
            description: dto.overview
        )
    }
}
