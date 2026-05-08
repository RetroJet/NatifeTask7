//
//  UIView + AddSubviews.swift
//  NatifeTask7
//
//  Created by Nazar on 19.04.2026.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }
}
