//
//  SocialView.swift
//  AniHyou
//
//  Created by Axel Lopez on 26/02/2023.
//

import SwiftUI
import Kingfisher
import AniListAPI

struct UserSocialView: View {

    let userId: Int
    @State private var socialType = 0
    @StateObject private var viewModel = UserSocialViewModel()
    private let gridColumns = [
        GridItem(.adaptive(minimum: 95))
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Picker("", selection: $socialType) {
                Text("Following").tag(0)
                Text("Followers").tag(1)
            }
            LazyVGrid(columns: gridColumns) {
                switch socialType {
                case 0:
                    ForEach(viewModel.followings, id: \.id) { user in
                        NavigationLink(destination: ProfileView(userId: user.id)) {
                            UserLargeItemView(user: user.fragments.userFollow)
                        }
                        .buttonStyle(.plain)
                    }

                    if viewModel.hasNextPageFollowings {
                        ProgressView()
                            .task {
                                await viewModel.getFollowings(userId: userId)
                            }
                    }
                case 1:
                    ForEach(viewModel.followers, id: \.id) { user in
                        NavigationLink(destination: ProfileView(userId: user.id)) {
                            UserLargeItemView(user: user.fragments.userFollow)
                        }
                        .buttonStyle(.plain)
                    }

                    if viewModel.hasNextPageFollowers {
                        ProgressView()
                            .task {
                                await viewModel.getFollowers(userId: userId)
                            }
                    }
                default:
                    ProgressView()
                }
            }
        }
    }
}

struct UserLargeItemView: View {

    let user: UserFollow
    private let imageWidth: CGFloat = 80
    private let imageHeight: CGFloat = 80

    var body: some View {
        VStack {
            KFImage(URL(string: user.avatar?.large ?? ""))
                .placeholder {
                    CoverPlaceholderView(systemName: "hourglass", width: imageWidth, height: imageHeight)
                }
                .imageCover(width: imageWidth, height: imageHeight)

            Text(user.name)
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    UserSocialView(userId: 208863)
}
