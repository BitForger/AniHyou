//
//  MangaQuickStats.swift
//  AniHyou
//
//  Created by Noah Kovacs on 6/25/23.
//

import Foundation
import SwiftUI

struct MangaQuickStats: View {
    
    var userId: Int?
    @StateObject private var overviewStatsModel = OverviewStatsViewModel()
    
    var body: some View {
        if overviewStatsModel.mangaStats != nil && overviewStatsModel.mangaStats!.count > 0 {
            Divider()
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    MediaStatView(name: "Total Manga", value: String(overviewStatsModel.mangaStats!.count))
                    MediaStatView(name: "Chapters Read", value: String(overviewStatsModel.mangaStats!.chaptersRead))
                    MediaStatView(name: "Volumes Read", value: String(overviewStatsModel.mangaStats!.volumesRead))
                    MediaStatView(name: "Mean Score", value: String(format: "%.2f", overviewStatsModel.mangaStats!.meanScore), showDivider: false)
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
            }
            Divider()
        } else if overviewStatsModel.mangaStats == nil {
            HStack {
                ProgressView()
            }
            .padding(16)
            .onAppear {
                if userId != nil {
                    overviewStatsModel.getMangaOverview(userId: userId!)
                }
            }
        } else {
            EmptyView()
        }
    }
}
