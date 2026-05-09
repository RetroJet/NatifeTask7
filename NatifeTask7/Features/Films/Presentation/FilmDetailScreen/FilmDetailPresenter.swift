//
//  FilmDetailPresenter.swift
//  NatifeTask7
//
//  Created by Nazar on 05.05.2026.
//

import Foundation

protocol FilmDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapTrailer()
    func didTapPoster()
}

final class FilmDetailPresenter {
    
    // MARK: - Properties
    
    private var poster: URL?
    private var trailerKey: String?
    private let filmId: Int
    private let initialTitle: String
    
    private weak var viewController: FilmDetailViewControllerProtocol?
    private let dataRepository: any DataRepositoryProtocol
    private let viewStateFactory: FilmDetailViewStateFactoryProtocol
    private let router: FilmDetailRouterProtocol
    
    // MARK: - Initialization
    
    init(
        filmId: Int,
        title: String,
        viewController: FilmDetailViewControllerProtocol,
        dataRepository: any DataRepositoryProtocol,
        viewStateFactory: FilmDetailViewStateFactoryProtocol,
        router: FilmDetailRouterProtocol
    ) {
        self.filmId = filmId
        self.initialTitle = title
        self.viewController = viewController
        self.dataRepository = dataRepository
        self.viewStateFactory = viewStateFactory
        self.router = router
    }
}

// MARK: - Private Methods

private extension FilmDetailPresenter {
    func makeState(film: FilmDetailInfo, trailer: TrailerInfo?) -> FilmDetailViewState {
        viewStateFactory.make(FilmDetailViewStateFactoryInput(film: film, trailer: trailer))
    }
    
    func loadDetail() async {
        await MainActor.run { viewController?.showLoader() }
        do {
            async let detail = dataRepository.fetchFilm(id: filmId)
            async let trailer = dataRepository.fetchTrailer(id: filmId)
        
            let resolvedTrailer = try await trailer
            trailerKey = resolvedTrailer?.key
            let viewState = makeState(film: try await detail, trailer: resolvedTrailer)
            poster = viewState.item.poster
            
            await MainActor.run {
                viewController?.render(viewState)
                viewController?.hideLoader()
            }
            
        } catch {
            await MainActor.run {
                viewController?.showError(error.localizedDescription)
                viewController?.hideLoader()
            }
        }
    }
}

// MARK: - FilmDetailPresenterProtocol

extension FilmDetailPresenter: FilmDetailPresenterProtocol {
    func viewDidLoad() {
        viewController?.setTitle(initialTitle)
        Task { await loadDetail() }
    }
    
    func didTapTrailer() {
        guard let key = trailerKey else { return }
        router.openTrailer(key)
    }
    
    func didTapPoster() {
        router.openPoster(poster)
    }
}
