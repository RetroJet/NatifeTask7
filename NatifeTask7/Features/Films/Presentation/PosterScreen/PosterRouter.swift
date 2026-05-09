//
//  PosterRouter.swift
//  NatifeTask7
//
//  Created by Nazar on 08.05.2026.
//

import UIKit

protocol PosterRouterProtocol: AnyObject {
    func dismiss()
}

final class PosterRouter {
    
    // MARK: - Properties
    
    weak var viewController: UIViewController?
}

// MARK: - PosterRouterProtocol

extension PosterRouter: PosterRouterProtocol {
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
