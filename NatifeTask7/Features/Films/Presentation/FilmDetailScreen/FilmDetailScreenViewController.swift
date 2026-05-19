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
}

final class FilmDetailViewController: BaseViewController<FilmDetailPresenterProtocol> {
    
    // MARK: - UI Elements
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.kf.indicatorType = .activity
        image.isUserInteractionEnabled = true
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
        button.isHidden = true
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
    
    // MARK: - Properties
    
    lazy var activityIndicator = makeActivityIndicator()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        presenter.viewDidLoad()
    }
}

// MARK: - FilmDetailViewControllerProtocol

extension FilmDetailViewController: FilmDetailViewControllerProtocol {
    func render(_ state: FilmDetailViewState) {
        title = state.title
        
        switch state.kind {
        case .loading:
            activityIndicator.startAnimating()
        case .content(let content):
            activityIndicator.stopAnimating()
            renderContent(content)
        case .error(let message):
            activityIndicator.stopAnimating()
            showError(message)
        }
    }
}

// MARK: - ActivityIndicatableProtocol

extension FilmDetailViewController: ActivityIndicatableProtocol {}

// MARK: - Private Methods

private extension FilmDetailViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubviews([
            scrollView
        ])
        
        setupActivityIndicator()
        
        scrollView.addSubview(contentView)
        contentView.addSubviews([
            imageView,
            infoStackView,
            mediaStackView,
            descriptionLabel
        ])
        
        infoStackView.addArrangedSubviews([
            titleLabel,
            subtitleLabel,
            genreLabel
        ])
        
        mediaStackView.addArrangedSubviews([
            trailerButton,
            spacerView,
            ratingLabel
        ])
        
        setupNavigationBar()
        setupGestures()
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
    }
    
    func renderContent(_ content: FilmDetailViewState.Item) {
        imageView.kf.setImage(with: content.poster)
        titleLabel.text = content.title
        subtitleLabel.text = content.country
            .joined(separator: Constant.UIString.separator) + Constant.UIString.separator + content.date
        trailerButton.isHidden = content.trailer == nil
        genreLabel.text = content.genres
        ratingLabel.text = "\(Constant.UIString.ratingTitle) \(content.rating)"
        descriptionLabel.text = content.description
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: CommonTextError.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: CommonText.ok, style: .default))
        present(alert, animated: true)
    }
    
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(posterTapped))
        imageView.addGestureRecognizer(tap)
    }
    
    @objc
    func posterTapped() {
        presenter.didTapPoster()
    }
    
    @objc
    func trailerButtonTapped() {
        presenter.didTapTrailer()
    }
    
    enum Constant {
        enum UIString {
            static let ratingTitle = String(localized: "film_detail_rating_title")
            static let separator = ", "
        }
    }
}
