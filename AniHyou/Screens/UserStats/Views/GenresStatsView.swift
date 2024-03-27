//
//  GenresStatsView.swift
//  AniHyou
//
//  Created by Axel Lopez on 27/03/2024.
//

import SwiftUI
import AniListAPI

struct GenresStatsView: View {
    
    let userId: Int
    let mediaType: MediaType
    @StateObject private var viewModel = GenresStatsViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.isLoading {
                HorizontalProgressView()
                Spacer()
            } else {
                Picker("Distribution type", selection: $viewModel.distribution) {
                    ForEach(StatDistributionType.allCases, id: \.self) {
                        Text($0.localizedName)
                    }
                }
                .padding(.horizontal, 4)
                
                let genres = if mediaType == .anime {
                    viewModel.animeGenres
                } else {
                    viewModel.mangaGenres
                }
                LazyVStack {
                    ForEach(Array(genres.enumerated()), id: \.element.genre) { index, stat in
                        PositionalStatItemView(
                            name: stat.genre ?? "",
                            position: index + 1,
                            count: stat.count,
                            meanScore: stat.meanScore,
                            minutesWatched: stat.minutesWatched,
                            chaptersRead: stat.chaptersRead
                        )
                        .padding()
                        Divider()
                    }
                }
            }
        }//:VStack
        .frame(minHeight: 500)
        .onAppear {
            viewModel.getGenresStats(userId: userId, mediaType: mediaType)
        }
        .onChange(of: viewModel.distribution) { _ in
            viewModel.getGenresStats(userId: userId, mediaType: mediaType)
        }
    }
}

#Preview {
    ScrollView {
        GenresStatsView(userId: 208863, mediaType: .manga)
    }
}
