//
//  FilmDetailScreenViewController.swift
//  NatifeTask7
//
//  Created by Nazar on 04.05.2026.
//

import Kingfisher
import SnapKit
import UIKit

protocol FilmDetailViewControllerProtocol: AnyObject {
    func render(_ state: FilmDetailViewState)
    func setTitle(_ title: String)
    func showError(_ message: String)
    func showLoader()
    func hideLoader()
}

final class FilmDetailViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var trailerButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.setImage(.init(resource: .playIcon), for: .normal)
        button.addTarget(self, action: #selector(trailerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var mediaStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var spacerView: UIView = {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return spacer
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        return indicator
    }()
    
    // MARK: - Properties
    
    private var presenter: FilmDetailPresenterProtocol!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupLayout()
        presenter.viewDidLoad()
    }
}

// MARK: - Internal Methods

extension FilmDetailViewController {
    func inject(presenter: FilmDetailPresenterProtocol) {
        self.presenter = presenter
    }
}

// MARK: - Private Methods

private extension FilmDetailViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(
            scrollView,
            activityIndicator
        )
        
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            imageView,
            infoStackView,
            mediaStackView,
            descriptionLabel
        )
        
        infoStackView.addArrangedSubiviews(
            titleLabel,
            subtitleLabel,
            genreLabel
        )
        
        mediaStackView.addArrangedSubiviews(
            trailerButton,
            spacerView,
            ratingLabel
        )
        
        imageView.kf.indicatorType = .activity
    }
    
    func setupNavigationBar() {
        title = nil
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .separator
        appearance.backgroundColor = .white
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.width).multipliedBy(3.0 / 4.0)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        trailerButton.snp.makeConstraints { make in
            make.size.equalTo(32)
        }
        
        mediaStackView.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(mediaStackView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc
    func trailerButtonTapped() {
        presenter.didTapTrailer()
    }
}

// MARK: - FilmDetailViewControllerProtocol

extension FilmDetailViewController: FilmDetailViewControllerProtocol {
    func render(_ state: FilmDetailViewState) {
        imageView.kf.setImage(with: state.item.poster)
        titleLabel.text = state.item.title
        subtitleLabel.text = state.item.country.joined(separator: ", ") + ", " + state.item.date
        trailerButton.isHidden = state.item.trailer == nil
        genreLabel.text = state.item.genres
        ratingLabel.text = state.item.rating
        descriptionLabel.text = state.item.description
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: CommonText.error, message: message, preferredStyle: .alert)
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
