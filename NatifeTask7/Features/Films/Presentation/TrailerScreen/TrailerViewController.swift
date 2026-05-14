//
//  TrailerViewController.swift
//  NatifeTask7
//
//  Created by Nazar on 09.05.2026.
//

import SnapKit
import UIKit
import YouTubeiOSPlayerHelper

final class TrailerViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var playerView = YTPlayerView()
    
    // MARK: - Properties
    
    private let key: String
    
    // MARK: - Initialization
    
    init(key: String) {
        self.key = key
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        playerView.load(withVideoId: key)
    }
}

// MARK: - Private Methods

private extension TrailerViewController {
    func setupView() {
        view.backgroundColor = .black
        view.addSubview(playerView)
    }
    
    func setupLayout() {
        playerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
