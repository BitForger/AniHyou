//
//  StaffInfoType.swift
//  AniHyou
//
//  Created by Axel Lopez on 02/06/2023.
//

import Foundation
import SwiftUI

public enum CharacterInfoType: Equatable, Hashable, CaseIterable {
    case overview
    case media
}

extension CharacterInfoType {
    var localizedName: LocalizedStringKey {
        switch self {
        case .overview:
            "Overview"
        case .media:
            "Media"
        }
    }

    var systemImage: String {
        switch self {
        case .overview:
            "info.circle"
        case .media:
            "play.square"
        }
    }
}
