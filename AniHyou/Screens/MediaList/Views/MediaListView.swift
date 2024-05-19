//
//  MediaListView.swift
//  AniHyou
//
//  Created by Axel Lopez on 18/6/22.
//

import SwiftUI
import AniListAPI

private extension View {
    @ViewBuilder
    func listStyle() -> some View {
        if isPhone {
            self.listStyle(.inset)
        } else {
            self.listStyle(.automatic)
        }
    }
}

struct MediaListView: View {

    let type: MediaType
    var userId: Int?
    var isMyList: Bool {
        userId == nil
    }
    @ObservedObject var viewModel: MediaListViewModel
    @State private var showingEditSheet = false

    @AppStorage(LIST_SORT) private var sort = MediaListSort.updatedTimeDesc
    @AppStorage(LIST_SORT_ORDER) private var sortAscending = false
    @AppStorage(LIST_STYLE_KEY) private var listItemsStyle = 0
    @AppStorage(INCREMENT_LONG_SWIPE_DIRECTION_KEY) private var incrementLongSwipeDirection: LongSwipeDirection = .right

    var body: some View {
        List {
            if viewModel.searchText.isEmpty {
                ForEach(viewModel.mediaList, id: \.uniqueListId) { item in
                    if let details = item.media?.fragments.basicMediaDetails {
                        buildListItem(
                            details: details,
                            entry: item.fragments.basicMediaListEntry,
                            schedule: item.media?.nextAiringEpisode?.fragments.airingEpisode,
                            showStatus: viewModel.selectedListName == nil
                        )
                    }
                }
                
                if viewModel.hasNextPage {
                    HorizontalProgressView()
                        .task {
                            await viewModel.getUserMediaList(otherUserId: userId)
                        }
                }
            } else {
                ForEach(viewModel.filteredMedia, id: \.id) { media in
                    if let entry = media.mediaListEntry?.fragments.basicMediaListEntry {
                        buildListItem(
                            details: media.fragments.basicMediaDetails,
                            entry: entry,
                            schedule: media.nextAiringEpisode?.fragments.airingEpisode,
                            showStatus: true
                        )
                    }
                }
                
                if viewModel.isLoading {
                    HorizontalProgressView()
                }
            }
        }//:List
        .listStyle()
        .searchable(text: $viewModel.searchText)
        .refreshable {
            if viewModel.searchText.isEmpty {
                viewModel.refreshList()
            }
        }
        .onChange(of: sort) { newValue in
            viewModel.onSortChanged(newValue, isAscending: sortAscending)
        }
        .onChange(of: sortAscending) { newValue in
            viewModel.onSortChanged(sort, isAscending: newValue)
        }
        .onSubmit(of: .search) {
            Task {
                await viewModel.filterList()
            }
        }
        .onReceive(
            viewModel.$searchText.debounce(for: .seconds(2), scheduler: RunLoop.main)
        ) { _ in
            Task {
                await viewModel.filterList()
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(for: "updatedMediaListEntry")
        ) { notification in
            if let entry = notification.object as? BasicMediaListEntry {
                Task {
                    await viewModel.onEntryUpdated(entry)
                }
            }
        }
        .onAppear {
            viewModel.onSortChanged(sort, isAscending: sortAscending)
        }
        .sheet(isPresented: $showingEditSheet) {
            if let details = viewModel.selectedDetails,
               let entry = viewModel.selectedEntry
            {
                MediaListEditView(
                    mediaDetails: details,
                    mediaList: entry,
                    onSave: { entry in
                        Task {
                            await viewModel.onEntryUpdated(entry)
                        }
                    },
                    onDelete: {
                        viewModel.onEntryDeleted(entryId: entry.id)
                    }
                )
            }
        }
        .navigationDestination(isPresented: $viewModel.showingRandomEntry) {
            MediaDetailsView(mediaId: viewModel.randomId ?? 0)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Picker("Sort", selection: $sort) {
                        ForEach(MediaListSort.allCasesForUi, id: \.self) {
                            Text($0.localizedName).tag($0)
                        }
                    }
                    Picker("Order", selection: $sortAscending) {
                        Text("Ascending").tag(true)
                        Text("Descending").tag(false)
                    }
                    
                    Button("Random", systemImage: "shuffle") {
                        Task {
                            await viewModel.getRandomEntryId()
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .navigationTitle(navigationTitle)
    }
    
    var navigationTitle: String {
        if let status = viewModel.selectedListName.asMediaListStatus() {
            let localizedKey = String.LocalizationValue(
                stringLiteral: status.localizedStringKey
            )
            return String(localized: localizedKey)
        } else if let listName = viewModel.selectedListName {
            return listName
        } else {
            return "All"
        }
    }

    @ViewBuilder
    // swiftlint:disable:next function_body_length
    func buildListItem(
        details: BasicMediaDetails,
        entry: BasicMediaListEntry,
        schedule: AiringEpisode?,
        showStatus: Bool
    ) -> some View {
        NavigationLink(destination: MediaDetailsView(mediaId: details.id)) {
            switch listItemsStyle {
            case 1:
                MediaListItemMinimalView(
                    details: details,
                    entry: entry,
                    schedule: schedule,
                    showStatus: showStatus
                )
            case 2:
                MediaListItemCompactView(
                    details: details,
                    entry: entry,
                    schedule: schedule,
                    showStatus: showStatus
                )
            default:
                MediaListItemStandardView(
                    details: details,
                    entry: entry,
                    schedule: schedule,
                    showStatus: showStatus
                )
            }
        }
        .swipeActions(edge: .leading) {
            if isMyList
                && incrementLongSwipeDirection == .right
                && entry.shouldShowIncrementButton
            {
                Button(
                    action: {
                        Task {
                            await viewModel.updateEntryProgress(of: entry)
                        }
                    },
                    label: {
                        if type == .anime {
                            Label("Ep", systemImage: "plus")
                            // should show a sheet to add a rating
                        } else if type == .manga {
                            Label("Ch", systemImage: "plus")
                        }
                    }
                )
                .tint(.green)
            }
        }
        .swipeActions(edge: .trailing) {
            if isMyList {
                if incrementLongSwipeDirection == .left
                    && entry.shouldShowIncrementButton
                {
                    Button(
                        action: {
                            Task {
                                await viewModel.updateEntryProgress(of: entry)
                            }
                        },
                        label: {
                            if type == .anime {
                                Label("Ep", systemImage: "plus")
                                // should show a sheet to add a rating
                            } else if type == .manga {
                                Label("Ch", systemImage: "plus")
                            }
                        }
                    )
                    .tint(.green)
                }
                Button(
                    action: {
                        viewModel.selectedDetails = details
                        viewModel.selectedEntry = entry
                        showingEditSheet = true
                    },
                    label: {
                        Label("Edit", systemImage: "square.and.pencil")
                    }
                )
                .tint(.blue)
            }
        }
        .mediaContextMenu(mediaId: details.id, mediaType: type, mediaListStatus: entry.status?.value)
    }
}

#Preview {
    NavigationStack {
        MediaListView(type: .anime, userId: 208863, viewModel: MediaListViewModel())
    }
}
