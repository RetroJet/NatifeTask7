//
//  FilmsListSkeletonCell.swift
//  NatifeTask7
//
//  Created by Nazar on 15.05.2026.
//

import SnapKit
import UIKit

final class FilmsListSkeletonCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
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
            x: Constant.Shadow.inset,
            y: bounds.height - 12,
            width: bounds.width - Constant.Shadow.inset * 2,
            height: 10
        )
        layer.shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: 5).cgPath
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        containerView.layer.sublayers?
            .filter { $0.name == Constant.Key.gradientKey }
            .forEach { $0.removeFromSuperlayer() }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal Methods

extension FilmsListSkeletonCell {
    func startShimmer() {
        layoutIfNeeded()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = Constant.Key.gradientKey
        gradientLayer.frame = containerView.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.withAlphaComponent(0.5).cgColor,
            UIColor.white.withAlphaComponent(0).cgColor
        ]
        gradientLayer.locations = [-1.0, -0.5, 0.0]
        
        let animation = CABasicAnimation(keyPath: Constant.Key.animationKey)
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.2
        animation.repeatCount = .infinity
        
        gradientLayer.add(animation, forKey: Constant.Key.gradientKey)
        containerView.layer.addSublayer(gradientLayer)
    }
}

// MARK: - Private Methods

private extension FilmsListSkeletonCell {
    func setupView() {
        contentView.addSubview(containerView)
        
        addShadow(
            shadowColor: UIColor.black.cgColor,
            shadowOpacity: 1,
            shadowOffset: CGSize(width: 0, height: 1),
            shadowRadius: 3
        )
        
    }
    
    func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    enum Constant {
        enum Key {
            static let gradientKey = "shimmer"
            static let animationKey = "locations"
        }
        
        enum Shadow {
            static let inset: CGFloat = 6
        }
    }
}
