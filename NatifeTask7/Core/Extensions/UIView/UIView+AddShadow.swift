//
//  UIView+AddShadow.swift
//  NatifeTask7
//
//  Created by Nazar on 17.05.2026.
//

import UIKit

extension UIView {
    func addShadow(
        shadowColor: CGColor,
        shadowOpacity: Float,
        shadowOffset: CGSize,
        shadowRadius: CGFloat
    ) {
        layer.shadowColor = shadowColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
    }
}
