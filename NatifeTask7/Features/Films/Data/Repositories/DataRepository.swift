//
//  DataRepository.swift
//  NatifeTask7
//
//  Created by Nazar on 24.04.2026.
//

import Foundation

protocol DataRepositoryProtocol {
    func fetchFilms(page: Int) async throws -> FilmsPage
    func fetchGenres() async throws -> [GenresInfo]
    func fetchFilm(id: Int) async throws -> FilmDetailInfo
    func fetchTrailer(id: Int) async throws -> TrailerInfo?
}

nonisolated final class DataRepository {
    
    // MARK: - Properties
    
    private let networkService: any NetworkServiceProtocol
    
    // MARK: - Initialization
    
    init(networkService: any NetworkServiceProtocol) {
        self.networkService = networkService
    }
}

// MARK: - DataRepositoryProtocol

extension DataRepository: DataRepositoryProtocol {
    func fetchFilms(page: Int = 1) async throws -> FilmsPage {
        let response: FilmsListResponse = try await networkService.request(from: FilmsEndpoint.popular(page: page))
        return FilmsListMapper.toDomain(response)
    }
    
    func fetchGenres() async throws -> [GenresInfo] {
        let response: GenresResponse = try await networkService.request(from: GenresEndpoint.genres)
        return GenresMapper.toDomain(response)
    }
    
    func fetchFilm(id: Int) async throws -> FilmDetailInfo {
        let response: FilmDetailDTO = try await networkService.request(from: FilmEndpoint.detail(id: id))
        return FilmDetailMapper.toDomain(response)
    }
    
    func fetchTrailer(id: Int) async throws -> TrailerInfo? {
        let response: TrailerResponse = try await networkService.request(from: FilmEndpoint.trailer(id: id))
        return TrailerMapper.toDomain(response)
    }
}
