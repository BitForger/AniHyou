//
//  MediaRankType.swift
//  AniHyou
//
//  Created by Axel Lopez on 11/08/2023.
//

import SwiftUI
import AniListAPI

extension MediaRankType {

    var systemImage: String {
        switch self {
        case .rated:
            "star"
        case .popular:
            "heart"
        }
    }

    var color: Color {
        switch self {
        case .rated:
            .yellow
        case .popular:
            .pink
        }
    }
    
    var localizedContext: LocalizedStringKey {
        switch self {
        case .rated:
            "Highest rated"
        case .popular:
            "Most popular"
        }
    }
}
