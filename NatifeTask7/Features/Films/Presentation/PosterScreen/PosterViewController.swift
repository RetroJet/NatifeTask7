//
//  PosterViewController.swift
//  NatifeTask7
//
//  Created by Nazar on 08.05.2026.
//

import Kingfisher
import SnapKit
import UIKit

protocol PosterViewControllerProtocol: AnyObject {
    func render(_ state: PosterViewState)
}

final class PosterViewController: BaseViewController<PosterPresenterProtocol> {
    
    // MARK: - UI Elements
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = Constant.Zoom.minimumZoom
        scrollView.maximumZoomScale = Constant.Zoom.maximumZoom
        scrollView.bouncesZoom = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.kf.indicatorType = .activity
        return image
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: Constant.Icon.closeIcon), for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        presenter.viewDidLoad()
    }
}

// MARK: - PosterViewControllerProtocol

extension PosterViewController: PosterViewControllerProtocol {
    func render(_ state: PosterViewState) {
        imageView.kf.setImage(with: state.poster)
    }
}

// MARK: - UIScrollViewDelegate

extension PosterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { imageView }
}

// MARK: - Private Methods

private extension PosterViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubviews([
            scrollView,
            closeButton
        ])
        
        scrollView.addSubview(imageView)
        setupGestures()
    }
    
    func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(40)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide)
        }
    }
    
    func setupGestures() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc
    func handleSwipeDown() {
        presenter.didSwipeDown()
    }
    
    @objc
    func handleClose() {
        presenter.didTapClose()
    }
    
    enum Constant {
        enum Zoom {
            static let minimumZoom = 1.0
            static let maximumZoom = 4.0
        }
        
        enum Icon {
            static let closeIcon = "xmark"
        }
    }
}
