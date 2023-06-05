//
//  AnimesView.swift
//  AniHyou
//
//  Created by Axel Lopez on 9/6/22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @State private var showNotificationsSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    // MARK: - Airing
                    Group {
                        HStack(alignment: .center) {
                            Text("Airing Soon")
                                .font(.title2)
                                .bold()
                            Spacer()
                            NavigationLink("See All", destination: CalendarAnimeView())
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        ZStack {
                            if viewModel.airingAnimes.count == 0 {
                                Text("No anime for today\n(*´-`)")
                                    .multilineTextAlignment(.center)
                                    .frame(alignment: .center)
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(viewModel.airingAnimes, id: \.?.media?.id) {
                                        if let item = $0 {
                                            NavigationLink(destination: MediaDetailsView(mediaId: item.media!.id)) {
                                                HListItemWithSubtitleView(title: item.media?.title?.userPreferred, subtitle: "Airing in \(item.timeUntilAiring.secondsToLegibleText())", imageUrl: item.media?.coverImage?.large, meanScore: item.media?.meanScore)
                                                    .padding(.leading, 8)
                                                    .frame(width: 280, alignment: .leading)
                                            }
                                        }
                                    }
                                }//:HStack
                                .padding(.leading, 8)
                            }//:HScrollView
                            .frame(height: 145)
                            .onAppear {
                                viewModel.getAiringAnimes()
                            }
                        }//:ZStack
                        Divider()
                    }
                    
                    // MARK: - Season
                    Group {
                        HStack(alignment: .center) {
                            Text("\(viewModel.nowAnimeSeason.season.localizedName) \(String(viewModel.nowAnimeSeason.year))")
                                .font(.title2)
                                .bold()
                            Spacer()
                            NavigationLink("See All", destination: AnimeSeasonListView(season: viewModel.nowAnimeSeason.season))
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        ZStack {
                            if viewModel.seasonAnimes.count == 0 {
                                ProgressView()
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(alignment: .top) {
                                    ForEach(viewModel.seasonAnimes, id: \.?.id) {
                                        if let item = $0 {
                                            NavigationLink(destination: MediaDetailsView(mediaId: item.id)) {
                                                VListItemView(title: item.title?.userPreferred ?? "", imageUrl: item.coverImage?.large, meanScore: item.meanScore)
                                                    .padding(.trailing, 4)
                                            }
                                        }
                                    }
                                }//:HStack
                                .padding(.leading, 14)
                            }//:HScrollView
                            .frame(minHeight: 180)
                            .onAppear {
                                viewModel.getSeasonAnimes()
                            }
                        }//:ZStack
                        Divider()
                    }
                    
                    //MARK: - Trending Anime
                    Group {
                        HStack(alignment: .center) {
                            Text("Trending Anime")
                                .font(.title2)
                                .bold()
                            Spacer()
                            NavigationLink("See All", destination: TrendingListView(viewModel: viewModel, mediaType: .anime))
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        ZStack {
                            if viewModel.trendingAnimes.count == 0 {
                                ProgressView()
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(alignment: .top) {
                                    ForEach(viewModel.trendingAnimes, id: \.?.id) {
                                        if let item = $0 {
                                            NavigationLink(destination: MediaDetailsView(mediaId: item.id)) {
                                                VListItemView(title: item.title?.userPreferred ?? "", imageUrl: item.coverImage?.large, meanScore: item.meanScore)
                                                    .padding(.trailing, 4)
                                            }
                                        }
                                    }
                                }//:HStack
                                .padding(.leading, 14)
                            }//:HScrollView
                            .frame(minHeight: 180)
                            .onAppear {
                                viewModel.getTrendingAnimes()
                            }
                        }//:ZStack
                        Divider()
                    }
                    
                    //MARK: - Next Season
                    Group {
                        HStack(alignment: .center) {
                            Text("Next Season")
                                .font(.title2)
                                .bold()
                            Spacer()
                            NavigationLink("See All", destination: AnimeSeasonListView(season: viewModel.nextAnimeSeason.season, selectedYear: viewModel.nextAnimeSeason.year))
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        ZStack {
                            if viewModel.nextSeasonAnimes.count == 0 {
                                ProgressView()
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(alignment: .top) {
                                    ForEach(viewModel.nextSeasonAnimes, id: \.?.id) {
                                        if let item = $0 {
                                            NavigationLink(destination: MediaDetailsView(mediaId: item.id)) {
                                                VListItemView(title: item.title?.userPreferred ?? "", imageUrl: item.coverImage?.large, meanScore: item.meanScore)
                                                    .padding(.trailing, 4)
                                            }
                                        }
                                    }
                                }//:HStack
                                .padding(.leading, 14)
                            }//:HScrollView
                            .frame(minHeight: 180)
                            .onAppear {
                                viewModel.getNextSeasonAnimes()
                            }
                        }//:ZStack
                        Divider()
                    }
                    
                    //MARK: - Trending manga
                    Group {
                        HStack(alignment: .center) {
                            Text("Trending Manga")
                                .font(.title2)
                                .bold()
                            Spacer()
                            NavigationLink("See All", destination: TrendingListView(viewModel: viewModel, mediaType: .manga))
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        ZStack {
                            if viewModel.trendingManga.count == 0 {
                                ProgressView()
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(alignment: .top) {
                                    ForEach(viewModel.trendingManga, id: \.?.id) {
                                        if let item = $0 {
                                            NavigationLink(destination: MediaDetailsView(mediaId: item.id)) {
                                                VListItemView(title: item.title?.userPreferred ?? "", imageUrl: item.coverImage?.large, meanScore: item.meanScore)
                                                    .padding(.trailing, 4)
                                            }
                                        }
                                    }
                                }//:HStack
                                .padding(.leading, 14)
                            }//:HScrollView
                            .frame(minHeight: 180)
                            .onAppear {
                                viewModel.getTrendingManga()
                            }
                        }//:ZStack
                        .padding(.bottom)
                    }
                }//:VStack
            }//:VScrollView
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem {
                    Button(action: { showNotificationsSheet = true }) {
                        Label("Notifications", systemImage: viewModel.notificationCount > 0 ? "bell.badge" : "bell")
                    }
                    .sheet(isPresented: $showNotificationsSheet) {
                        NotificationsView()
                    }
                    .onAppear {
                        viewModel.getNotificationCount()
                    }
                }
            }
        }//:NavigationView
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
