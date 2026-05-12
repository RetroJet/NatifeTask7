//
//  GenresMapper.swift
//  NatifeTask7
//
//  Created by Nazar on 01.05.2026.
//

struct GenresMapper {
    static func toDomain(_ response: GenresResponse) -> [GenresInfo] {
        response.genres.map { GenresInfo(id: $0.id, name: $0.name) }
    }
}
