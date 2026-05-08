//
//  TrailerMapper.swift
//  NatifeTask7
//
//  Created by Nazar on 05.05.2026.
//

struct TrailerMapper {
    static func toDomain(_ response: TrailerResponse) -> TrailerInfo? {
        guard let trailer = response.results.first(where: {
            $0.type == Constants.trailerType && $0.site == Constants.youtubeSite
        }) else { return nil }
        
        return TrailerInfo(key: trailer.key)
    }
}

private extension TrailerMapper {
    enum Constants {
        static let trailerType = "Trailer"
        static let youtubeSite = "YouTube"
    }
}
