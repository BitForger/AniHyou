//
//  TrendingListView.swift
//  AniHyou
//
//  Created by Axel Lopez on 05/06/2023.
//

import SwiftUI
import API

struct TrendingListView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    var mediaType: MediaType
    
    private let gridColumns = [
        GridItem(.adaptive(minimum: VListItemView.coverWidth + 15), alignment: .top)
    ]
    var trendingMedia: [MediaSortedQuery.Data.Page.Medium?] {
        switch mediaType {
        case .anime:
            return viewModel.trendingAnimes
        case .manga:
            return viewModel.trendingManga
        }
    }
    var page: Int {
        switch mediaType {
        case .anime:
            return viewModel.pageTrendingAnime
        case .manga:
            return viewModel.pageTrendingManga
        }
    }
    var hasNextPage: Bool {
        switch mediaType {
        case .anime:
            return viewModel.hasNextPageTrendingAnime
        case .manga:
            return viewModel.hasNextPageTrendingManga
        }
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: gridColumns) {
                ForEach(trendingMedia, id: \.?.id) {
                    if let media = $0 {
                        NavigationLink(destination: MediaDetailsView(mediaId: media.id)) {
                            VListItemView(title: media.title?.userPreferred ?? "", imageUrl: media.coverImage?.large, meanScore: media.meanScore)
                        }
                    }
                }
                if hasNextPage {
                    ProgressView()
                        .onAppear {
                            switch mediaType {
                            case .anime:
                                viewModel.getTrendingAnimes(page: page)
                            case .manga:
                                viewModel.getTrendingManga(page: page)
                            }
                        }
                }
            }//:LazyVGrid
        }//:VScrollView
        .navigationTitle("Trending \(mediaType.localizedName)")
    }
}

struct TrendingListView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingListView(viewModel: HomeViewModel(), mediaType: .anime)
    }
}
