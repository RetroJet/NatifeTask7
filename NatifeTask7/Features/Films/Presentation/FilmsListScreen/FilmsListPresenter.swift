//
//  FilmsListPresenter.swift
//  NatifeTask7
//
//  Created by Nazar on 23.04.2026.
//

import Foundation

enum SortOption: String, CaseIterable {
    case all = "All"
    case ratingDesc = "Rating: Hight to Low"
    case ratingAsc = "Rating: Low to Hight"
    case yearDesc = "Newest first"
    case yearAsc = "Oldest first"
}

protocol FilmsListPresenterProtocol: AnyObject {
    var currentSort: SortOption { get }
    func viewDidLoad()
    func didScrollNearEnd()
    func didPullToRefresh() async
    func didChangeSearchText(_ text: String)
    func didSelectSort(_ option: SortOption)
    //func didSelectFilm(_ film: )
}

final class FilmsListPresenter {
    
    // MARK: - Properties
    
    private var totalPages = 1
    private var currentPage = 1
    private var allFilms: [FilmsListInfo] = []
    private var isLoading = false
    private var genres: [GenresInfo] = []
    private var searchTask: Task<Void, Never>?
    private var currentQuery = Constants.currentQuery
    private(set) var currentSort: SortOption = .all
    
    private weak var viewController: FilmsListViewControllerProtocol?
    private let viewStateFactory: FilmsListViewStateFactoryProtocol
    private let dataRepository: any DataRepositoryProtocol
    private let router: FilmsListRouterProtocol
    
    // MARK: - Initialization
    
    init(
        viewController: FilmsListViewControllerProtocol,
        viewStateFactory: FilmsListViewStateFactoryProtocol,
        dataRepository: any DataRepositoryProtocol,
        router: FilmsListRouterProtocol
    ) {
        self.viewController = viewController
        self.viewStateFactory = viewStateFactory
        self.dataRepository = dataRepository
        self.router = router
    }
}

// MARK: - Private Methods

private extension FilmsListPresenter {
    func makeState(films: [FilmsListInfo], genres: [GenresInfo]) -> FilmsListViewState {
        viewStateFactory.make(FilmsListViewStateFactoryInput(films: films, genres: genres))
    }
    
    func loadInitial(showLoader: Bool = true) async {
        await withLoader(show: showLoader) {
            async let filmsPage = dataRepository.fetchFilms(page: 1)
            async let genresList = dataRepository.fetchGenres()
            
            let page = try await filmsPage
            genres = try await genresList
            allFilms = page.films
            currentPage = 1
            totalPages = page.totalPages
            
            await render()
        }
    }
    
    func loadNextPage() async {
        guard !isLoading, currentPage < totalPages else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let nextPage = currentPage + 1
            let page = try await dataRepository.fetchFilms(page: nextPage)
            let existingIds = Set(allFilms.map(\.id))
            let newFilms = page.films.filter { !existingIds.contains($0.id) }
            allFilms += newFilms
            
            currentPage = nextPage
            await render(animated: false)
        } catch {
            await handle(error)
        }
    }
    
    func withLoader(show: Bool = true, _ work: () async throws -> Void) async {
        if show { await MainActor.run { viewController?.showLoader() } }
        do {
            try await work()
        } catch {
            await handle(error)
        }
        if show { await MainActor.run { viewController?.hideLoader() } }
    }
    
    func render(animated: Bool = true) async {
        let trimmed = currentQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        let films = trimmed.count >= Constants.minSearchLenght
        ? allFilms.filter { $0.title.range(of: trimmed, options: .caseInsensitive) != nil }
        : allFilms
        let viewState = makeState(films: sorted(films), genres: genres)
        await MainActor.run {
            viewController?.render(viewState, animated: animated)
        }
    }
    
    func handle(_ error: Error) async {
        await MainActor.run {
            print("\(ErrorText.fetchFilms)\(error)")
            viewController?.showError(error.localizedDescription)
        }
    }
    
    func search(_ query: String) async {
        currentQuery = query
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= Constants.minSearchLenght else {
            await render()
            return
        }
        try? await Task.sleep(nanoseconds: Constants.nanoseconds)
        guard !Task.isCancelled else { return }
        await render()
    }
    
    func sorted(_ films: [FilmsListInfo]) -> [FilmsListInfo] {
        switch currentSort {
        case .all: return films
        case .ratingDesc: return films.sorted { $0.rating > $1.rating }
        case .ratingAsc: return films.sorted { $0.rating < $1.rating }
        case .yearDesc: return films.sorted { $0.date > $1.date }
        case .yearAsc: return films.sorted { $0.date < $1.date }
        }
    }
    
    enum Constants {
        static let currentQuery = ""
        static let minSearchLenght = 2
        static let nanoseconds: UInt64 = 500_000_000
    }
    
    enum ErrorText {
        static let fetchFilms = "Failed to fetch films"
    }
}

// MARK: - FilmsListPresenterProtocol

extension FilmsListPresenter: FilmsListPresenterProtocol {
    func viewDidLoad() {
        Task { await loadInitial() }
    }
    
    func didScrollNearEnd() {
        Task { await loadNextPage() }
    }
    
    func didPullToRefresh() async {
        await loadInitial(showLoader: false)
    }
    
    func didChangeSearchText(_ text: String) {
        searchTask?.cancel()
        searchTask = Task { await search(text) }
    }
    
    func didSelectSort(_ option: SortOption) {
        currentSort = option
        Task { await render() }
    }
}
