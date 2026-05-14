//
//  PosterViewStateFactory.swift
//  NatifeTask7
//
//  Created by Nazar on 06.05.2026.
//

import Foundation

protocol PosterViewStateFactoryProtocol {
    func make(poster: URL?) -> PosterViewState
}

struct PosterViewStateFactory: PosterViewStateFactoryProtocol {
    func make(poster: URL?) -> PosterViewState {
        PosterViewState(poster: poster)
    }
}
