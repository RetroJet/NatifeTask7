//
//  FilmsListCell.swift
//  NatifeTask7
//
//  Created by Nazar on 20.04.2026.
//

import Kingfisher
import SnapKit
import UIKit

final class FilmsListCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .yellow
        return label
    }()
    
    private lazy var spacerView: UIView = {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return spacer
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shadowRect = CGRect(
            x: 0,
            y: bounds.height - 8,
            width: bounds.width,
            height: 10
        )
        layer.shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: 5).cgPath
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        layer.shadowOpacity = 0
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal Methods

extension FilmsListCell {
    func render(with viewState: FilmsListItemViewState) {
        layer.shadowOpacity = 0.4
        imageView.kf.setImage(with: viewState.poster)
        titleLabel.text = viewState.title
        genresLabel.text = viewState.genre
        ratingLabel.text = viewState.rating
    }
}

// MARK: - Private Methods

private extension FilmsListCell {
    func setupView() {
        contentView.addSubviews(
            imageView,
            titleLabel,
            bottomStackView
        )
        
        contentView.clipsToBounds = true
        
        setupShadow()
        
        bottomStackView.addArrangedSubiviews(
            genresLabel,
            spacerView,
            ratingLabel
        )
    }
    
    func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
    }
    
    func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.bottom.equalTo(-30)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
    }
}
