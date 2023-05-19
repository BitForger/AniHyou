//
//  MediaListView.swift
//  AniHyou
//
//  Created by Axel Lopez on 18/6/22.
//

import SwiftUI
import API

struct MediaListView: View {
    
    var type: MediaType
    var status: MediaListStatus
    @StateObject private var viewModel = MediaListViewModel()
    @State private var showingEditSheet = false
    @State private var searchText = ""
    @AppStorage(LIST_STYLE_KEY) private var listStyle = 0
    
    var body: some View {
        List {
            ForEach(filteredMediaList, id: \.?.id) {
                if let item = $0 {
                    NavigationLink(destination: MediaDetailsView(mediaId: item.mediaId)) {
                        switch listStyle {
                        case 1:
                            MediaListItemMinimalView(item: item)
                        case 2:
                            MediaListItemCompactView(item: item)
                        default:
                            MediaListItemStandardView(item: item)
                        }
                    }
                    .swipeActions {
                        if viewModel.mediaListStatus == .current || viewModel.mediaListStatus == .repeating {
                            Button("+1") {
                                viewModel.updateEntryProgress(entryId: item.id, progress: item.progress! + 1)
                                // should show a sheet to add a rating
                            }
                            .tint(.green)
                        }
                        Button(action: {
                            viewModel.selectedItem = item
                            showingEditSheet = true
                        }) {
                            Label("Edit", systemImage: "square.and.pencil")
                        }
                        .tint(.blue)
                    }
                }

            }
                
            if viewModel.hasNextPage {
                ProgressView()
                    .onAppear {
                        viewModel.getUserMediaList()
                    }
            }
        }//:List
        .searchable(text: $searchText)
        .refreshable {
            viewModel.refreshList()
        }
        .onChange(of: viewModel.sort) { _ in
            viewModel.refreshList()
        }
        .onChange(of: viewModel.updatedEntry) { _ in
            viewModel.refreshList()
        }
        .onAppear {
            viewModel.mediaType = type
            viewModel.mediaListStatus = status
        }
        .sheet(isPresented: $showingEditSheet) {
            if viewModel.selectedItem != nil {
                MediaListEditView(mediaId: viewModel.selectedItem!.mediaId, mediaType: type, mediaList: viewModel.selectedItem!.fragments.basicMediaListEntry) {
                    viewModel.refreshList()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Picker("Sort", selection: $viewModel.sort) {
                        Text("Title").tag(MediaListSort.mediaTitleNativeDesc)
                        Text("Score").tag(MediaListSort.scoreDesc)
                        Text("Last Updated").tag(MediaListSort.updatedTimeDesc)
                        Text("Last Added").tag(MediaListSort.addedTimeDesc)
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }
            }
        }
        .navigationTitle(viewModel.mediaListStatus.localizedName)
    }
    
    var filteredMediaList: [UserMediaListQuery.Data.Page.MediaList?] {
        if searchText.isEmpty {
            return viewModel.mediaList
        } else {
            let filtered = viewModel.mediaList.filter { ($0?.media?.title?.userPreferred?.contains(searchText))!
            }
            if viewModel.hasNextPage {
                viewModel.getUserMediaList()
            }


            return filtered
        }
    }
}

struct MediaListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MediaListView(type: .anime, status: .current)
            MediaListView(type: .anime, status: .repeating)
        }
    }
}
