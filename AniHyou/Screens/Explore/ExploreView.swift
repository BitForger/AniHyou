//
//  ExploreView.swift
//  AniHyou
//
//  Created by Axel Lopez on 26/6/22.
//

import SwiftUI

private let cardHeight: CGFloat = 90

struct ExploreView: View {
    
    @ObservedObject var viewModel: SearchViewModel
    @Environment(\.isSearching) private var isSearching
    
    var body: some View {
        ZStack {
            if isSearching {
                switch viewModel.type {
                case .anime, .manga:
                    List {
                        HStack {
                            Text("Search type")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            Spacer()
                            Picker("Search type", selection: $viewModel.type) {
                                ForEach(SearchType.allCases, id: \.self) { type in
                                    Text(type.formatted)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        ForEach(viewModel.searchedMedia, id: \.?.id) { item in
                            if item != nil {
                                NavigationLink(destination: MediaDetailsView(mediaId: item!.id)) {
                                    HListItemWithSubtitleView(title: item!.title?.romaji, subtitle: "\(item!.format?.formatted ?? "") · \(item!.startDate?.year?.stringValue ?? "")", imageUrl: item!.coverImage?.large)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                case .characters:
                    Text("Characters")
                case .staff:
                    Text("Staff")
                case .studios:
                    Text("Studios")
                case .users:
                    Text("Users")
                }//:switch
            } else {//not searched
                ScrollView(.vertical) {
                        //MARK: Charts
                    VStack(alignment: .leading) {

                        Text("Charts")
                            .font(.title2)
                            .bold()
                            .padding(.top, 8)
                            .padding(.leading, 15)
                        Divider()
                            .padding(.leading)
                            .padding(.trailing)

                        //MARK: top
                        HStack(alignment: .center) {
                            NavigationLink(destination: MediaChartListView(title: "Top 100 Anime", type: .anime, sort: .scoreDesc)) {
                                RectangleTextView(text: "Top 100 Anime", color: Color("AniListBlue"))
                                    .padding(.leading)
                                    .frame(maxWidth: .infinity, minHeight: cardHeight)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            NavigationLink(destination: MediaChartListView(title: "Top 100 Manga", type: .manga, sort: .scoreDesc)) {
                                RectangleTextView(text: "Top 100 Manga", color: Color("AniListGreen"))
                                    .padding(.trailing)
                                    .frame(maxWidth: .infinity, minHeight: cardHeight)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }//:HStack

                        //MARK: popular
                        HStack(alignment: .center) {
                            NavigationLink(destination: MediaChartListView(title: "Popular Anime", type: .anime, sort: .popularityDesc)) {
                                RectangleTextView(text: "Popular Anime", color: Color("AniListOrange"))
                                    .padding(.leading)
                                    .frame(maxWidth: .infinity, minHeight: cardHeight)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            NavigationLink(destination: MediaChartListView(title: "Popular Manga", type: .manga, sort: .popularityDesc)) {
                                RectangleTextView(text: "Popular Manga", color: Color("AniListRed"))
                                    .padding(.trailing)
                                    .frame(maxWidth: .infinity, minHeight: cardHeight)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }//:HStack
                    }//:VStack
                }//:VScrollView
            }//:else
        }//:ZStack
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView(viewModel: SearchViewModel())
    }
}
