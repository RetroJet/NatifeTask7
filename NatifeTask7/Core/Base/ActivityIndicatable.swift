//
//  ActivityIndicatable.swift
//  NatifeTask7
//
//  Created by Nazar on 12.05.2026.
//

import SnapKit
import UIKit

protocol ActivityIndicatableProtocol: UIViewController {
    var activityIndicator: UIActivityIndicatorView { get }
}

extension ActivityIndicatableProtocol {
    func makeActivityIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        return indicator
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
