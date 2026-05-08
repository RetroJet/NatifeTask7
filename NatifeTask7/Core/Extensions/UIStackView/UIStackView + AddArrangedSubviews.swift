//
//  UIStackView + AddArrangedSubviews.swift
//  NatifeTask7
//
//  Created by Nazar on 20.04.2026.
//

import UIKit

extension UIStackView {
    func addArrangedSubiviews(_ views: UIView...) {
        views.forEach(addArrangedSubview)
    }
}
