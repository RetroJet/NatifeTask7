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
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - PosterRouterProtocol

extension PosterRouter: PosterRouterProtocol {
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
