//
//  DataRepositoryProtocol.swift
//  NatifeTask7
//
//  Created by Nazar on 11.05.2026.
//

protocol FilmsDataRepositoryProtocol {
    func fetchFilms(page: Int) async throws -> FilmsPage
    func fetchGenres() async throws -> [GenresInfo]
    func fetchFilm(by id: Int) async throws -> FilmDetailInfo
    func fetchTrailer(by id: Int) async throws -> TrailerInfo?
}
