//
//  MediaDetailsView.swift
//  AniHyou
//
//  Created by Axel Lopez on 18/6/22.
//

import SwiftUI

private let bannerHeight: CGFloat = 180

struct MediaDetailsView: View {
    
    var mediaId: Int
    @StateObject private var viewModel = MediaDetailsViewModel()
    @State private var infoType: MediaInfoType = .general
    @State private var attributedSynopsis = NSAttributedString(string: "Loading")
    
    @Environment(\.dismiss) private var dismiss
    @State var scrollOffset = CGFloat.zero
    private var hasScrolled: Bool {
        withAnimation {
            scrollOffset > 0
        }
    }
    
    var body: some View {
        Group {
            if viewModel.mediaDetails != nil {
                ObservableVScrollView(scrollOffset: $scrollOffset) { _ in
                    LazyVStack(alignment: .leading) {
                        // MARK: - Header
                        TopBannerView(imageUrl: viewModel.mediaDetails!.bannerImage, placeholderHexColor: viewModel.mediaDetails!.coverImage?.color, height: bannerHeight)
                        
                        // MARK: - Main info
                        MediaDetailsMainInfo(mediaId: mediaId, viewModel: viewModel)
                        
                        // MARK: - Main stats
                        ScrollView(.horizontal, showsIndicators: false) {
                            VStack {
                                Divider()
                                HStack {
                                    if let schedule = viewModel.mediaDetails?.nextAiringEpisode {
                                        MediaStatView(name: "Airing", value: "Ep \(schedule.episode) in \(schedule.timeUntilAiring.secondsToLegibleText())")
                                    }
                                    MediaStatView(name: "Average Score", value: "\(viewModel.mediaDetails?.averageScore ?? 0)%")
                                    MediaStatView(name: "Mean Score", value: "\(viewModel.mediaDetails?.meanScore ?? 0)%")
                                    MediaStatView(name: "Status", value: viewModel.mediaDetails?.status?.value?.localizedName ?? "Unknown")
                                    MediaStatView(name: "Popularity", value: (viewModel.mediaDetails?.popularity ?? 0).formatted())
                                    MediaStatView(name: "Favorites", value: (viewModel.mediaDetails?.favourites ?? 0).formatted(), showDivider: false)
                                }
                                .padding(.vertical, 4)
                                Divider()
                            }//:VStack
                            .padding(.leading)
                        }//:HScrollView
                        .padding(.top)
                        
                        // MARK: - Synopsis
                        ExpandableTextView(text: $attributedSynopsis)
                            .padding(.top)
                            .padding(.leading)
                            .padding(.trailing)
                        
                        // MARK: - More info
                        Picker("Info type", selection: $infoType) {
                            ForEach(MediaInfoType.allCases, id: \.self) { type in
                                Label(type.localizedName, systemImage: type.systemImage)
                            }
                        }
                        .pickerStyle(.segmented)
                        .labelStyle(.iconOnly)
                        .padding()
                        
                        ZStack {
                            switch infoType {
                            case .general:
                                MediaGeneralInfoView(viewModel: viewModel)
                            case .charactersAndStaff:
                                MediaCharactersAndStaffView(mediaId: mediaId)
                            case .relationsAndRecommendations:
                                MediaRelationsAndRecommendationsView(mediaId: mediaId)
                            case .stats:
                                MediaStatsView(mediaId: mediaId)
                            case .reviewsAndThreads:
                                MediaReviewsAndThreadsView(mediaId: mediaId)
                            }
                        }//:ZStack
                        .frame(minHeight: 200)
                    }//:VStack
                    .padding(.bottom)
                }//:VScrollView
                .edgesIgnoringSafeArea(.top)
            } else {
                ProgressView()
                    .onAppear {
                        viewModel.getMediaDetails(mediaId: mediaId)
                    }
            }
        }//:Group
        .navigationBarBackButtonHidden(!hasScrolled)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !hasScrolled {
                    ToolbarIconButton(symbolSystemName: "chevron.left") {
                        dismiss()
                    }
                    .transition(.slide)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.mediaDetails != nil {
                    if !hasScrolled {
                        ToolbarIconButton(symbolSystemName: viewModel.mediaDetails!.isFavourite ? "heart.fill" : "heart") {
                            viewModel.toggleFavorite()
                        }
                    } else {
                        Button(action: { viewModel.toggleFavorite() }) {
                            Image(systemName: viewModel.mediaDetails!.isFavourite ? "heart.fill" : "heart")
                        }
                    }
                }
            }
        }
        .onChange(of: viewModel.mediaDetails) { details in
            DispatchQueue.main.async {
                attributedSynopsis = details?.description?.htmlToAttributedString() ?? NSAttributedString(string: "No description")
            }
        }
    }
}

struct MediaDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MediaDetailsView(mediaId: 140960)
    }
}
