//
//  UserQuickStats.swift
//  AniHyou
//
//  Created by Noah Kovacs on 6/25/23.
//

import Foundation
import SwiftUI

struct AnimeQuickStats: View {
    
    var userId: Int?
    @StateObject private var overviewViewModel = OverviewStatsViewModel()
    
    var body: some View {
        if overviewViewModel.animeStats != nil && overviewViewModel.animeStats!.count > 0 {
            Divider()
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    MediaStatView(name: "Total Anime", value: String(overviewViewModel.animeStats!.count))
                    MediaStatView(name: "Episodes Watched", value: String(overviewViewModel.animeStats!.episodesWatched))
                    MediaStatView(name: "Days Watched", value: String(format: "%.2f", overviewViewModel.animeStats!.minutesWatched.minutesToDays()))
                    MediaStatView(name: "Mean Score", value: String(format: "%.2f", overviewViewModel.animeStats!.meanScore), showDivider: false)
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
            }
            Divider()
        } else {
            HStack {
                ProgressView()
            }
            .padding(16)
            .onAppear {
                if userId != nil {
                    overviewViewModel.getAnimeOverview(userId: userId!)
                }
            }
        }
    }
}
