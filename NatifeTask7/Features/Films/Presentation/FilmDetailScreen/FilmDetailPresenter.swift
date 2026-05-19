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
    private let dataRepository: any FilmsDataRepositoryProtocol
    private let viewStateFactory: FilmDetailViewStateFactoryProtocol
    private let router: FilmDetailRouterProtocol
    
    // MARK: - Initialization
    
    init(
        filmId: Int,
        title: String,
        dataRepository: any FilmsDataRepositoryProtocol,
        viewStateFactory: FilmDetailViewStateFactoryProtocol,
        viewController: FilmDetailViewControllerProtocol,
        router: FilmDetailRouterProtocol
    ) {
        self.filmId = filmId
        self.initialTitle = title
        self.dataRepository = dataRepository
        self.viewStateFactory = viewStateFactory
        self.viewController = viewController
        self.router = router
    }
}

// MARK: - FilmDetailPresenterProtocol

extension FilmDetailPresenter: FilmDetailPresenterProtocol {
    func viewDidLoad() {
        viewController?.render(FilmDetailViewState(title: initialTitle, kind: .loading))
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

// MARK: - Private Methods

private extension FilmDetailPresenter {
    func makeState(film: FilmDetailInfo, trailer: TrailerInfo?) -> FilmDetailViewState.Item {
        viewStateFactory.make(FilmDetailViewStateFactoryInput(film: film, trailer: trailer))
    }
    
    func loadDetail() async {
        do {
            async let detail = dataRepository.fetchFilm(by: filmId)
            async let trailer = dataRepository.fetchTrailer(by: filmId)
            
            let resolvedTrailer = try await trailer
            trailerKey = resolvedTrailer?.key
            let state = makeState(film: try await detail, trailer: resolvedTrailer)
            poster = state.poster
            
            await MainActor.run {
                viewController?.render(FilmDetailViewState(title: initialTitle, kind: .content(state)))
            }
            
        } catch {
            print("\(Constant.ErrorText.fetchFilm): \(error)")
            if case NetworkError.noInternet = error {
                await MainActor.run {
                    viewController?.render(FilmDetailViewState(title: initialTitle, kind: .error(error.localizedDescription)))
                }
            }
        }
    }
    
    enum Constant {
        enum ErrorText {
            static let fetchFilm = "Failed to fetch films"
        }
    }
}
