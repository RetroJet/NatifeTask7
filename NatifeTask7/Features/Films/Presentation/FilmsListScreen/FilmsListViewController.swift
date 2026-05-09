//
//  FilmsListViewController.swift
//  NatifeTask7
//
//  Created by Nazar on 18.04.2026.
//

import SnapKit
import UIKit

protocol FilmsListViewControllerProtocol: AnyObject {
    func render(_ state: FilmsListViewState, animated: Bool)
    func showError(_ message: String)
    func showLoader()
    func hideLoader()
}

final class FilmsListViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var rightBarButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: UIStrings.iconImageDecrease), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .white
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = UIStrings.searchBarTitle
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = .separator
        separator.layer.opacity = 0.7
        return separator
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createListLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: FilmsListCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.refreshControl = refreshControl
        collectionView.clipsToBounds = false
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Int, FilmsListItemViewState> = {
        let dataSource = UICollectionViewDiffableDataSource<Int, FilmsListItemViewState>(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            let cell: FilmsListCell = collectionView.dequeue(for: indexPath)
            cell.render(with: item)
            return cell
        }
        return dataSource
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresh
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        return indicator
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = UIStrings.emptyLabelTitle
        label.textColor = .gray
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: - Properties
    
    private var presenter: FilmsListPresenterProtocol!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupLayout()
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topInset = searchBar.frame.maxY - view.safeAreaInsets.top + Layout.searchBarTopInset
        collectionView.contentInset.top = topInset
    }
}

// MARK: - Internal Methods

extension FilmsListViewController {
    func inject(presenter: FilmsListPresenterProtocol) {
        self.presenter = presenter
    }
}

// MARK: - Private Methods

private extension FilmsListViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubviews(
            collectionView,
            separatorView,
            searchBar,
            activityIndicator,
            emptyLabel
        )
    }
    
    func setupNavigationBar() {
        title = FilmsListText.navigationBarTitle
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .separator
        appearance.backgroundColor = .white
        
        rightBarButton.showsMenuAsPrimaryAction = true
        rightBarButton.menu = makeSortMenu()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
    }
    
    func setupLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func createListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.3)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Layout.interGroupSpacing
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func applySnapshot(with items: [FilmsListItemViewState], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FilmsListItemViewState>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        diffableDataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    func makeSortMenu() -> UIMenu {
        let actions = SortOption.allCases.map { option in
            UIAction(
                title: option.rawValue,
                state: presenter.currentSort == option ? .on : .off
            ) { [weak self] _ in
                self?.presenter.didSelectSort(option)
                self?.rightBarButton.menu = self?.makeSortMenu()
            }
        }
        return UIMenu(children: actions)
    }
    
    @objc
    func handleRefresh() {
        Task {
            await presenter.didPullToRefresh()
            refreshControl.endRefreshing()
        }
    }
    
    enum UIStrings {
        static let iconImageDecrease = "line.3.horizontal.decrease"
        static let searchBarTitle = "Search"
        static let emptyLabelTitle = "No movies found"
    }
    
    enum Layout {
        static let searchBarTopInset: CGFloat = 10
        static let interGroupSpacing: CGFloat = 25
        static let paginationThreshold = 5
    }
}

// MARK: - FilmsListViewControllerProtocol

extension FilmsListViewController: FilmsListViewControllerProtocol {
    func render(_ state: FilmsListViewState, animated: Bool) {
        applySnapshot(with: state.items, animated: animated)
        emptyLabel.isHidden = !state.items.isEmpty
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: CommonTextError.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: CommonText.ok, style: .default))
        present(alert, animated: true)
    }
    
    func showLoader() {
        activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - UICollectionViewDelegate

extension FilmsListViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let total = diffableDataSource.snapshot().numberOfItems
        if indexPath.item >= total - Layout.paginationThreshold {
            presenter.didScrollNearEnd()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = diffableDataSource.itemIdentifier(for: indexPath) else { return }
        presenter.didSelectFilm(item.id)
    }
}

// MARK: - UISearchBarDelegate

extension FilmsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.didChangeSearchText(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
