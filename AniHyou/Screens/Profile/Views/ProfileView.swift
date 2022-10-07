//
//  ProfileView.swift
//  AniHyou
//
//  Created by Axel Lopez on 10/6/22.
//

import SwiftUI
import Kingfisher
import API

private let avatarSize: CGFloat = 110
private let bannerHeight: CGFloat = 30

extension Label {
    func labelButtonIcon() -> some View {
        self
            .labelStyle(.iconOnly)
            .font(.system(size: 22))
    }
    
    func toolbarMaterialLabel() -> some View {
        self
            .frame(width: 32, height: 32)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
    }
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showLogOutDialog = false
    @State private var infoType: ProfileInfoType = .activity
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                    profileHeader
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                    
                    if viewModel.myUserInfo != nil {
                        Section {
                            switch infoType {
                            case .activity:
                                UserActivityView(userId: viewModel.myUserInfo!.id)
                            case .about:
                                UserAboutView(userId: viewModel.myUserInfo!.id)
                            case .stats:
                                Text("Stats")
                            case .favorites:
                                UserFavoritesView(userId: viewModel.myUserInfo!.id)
                            case .social:
                                Text("Social")
                            }
                        } header: {
                            Picker("Info type", selection: $infoType) {
                                ForEach(ProfileInfoType.allCases, id: \.self) { type in
                                    Label(type.localizedName, systemImage: type.systemImage)
                                }
                            }
                            .pickerStyle(.segmented)
                            .labelStyle(.iconOnly)
                            .padding()
                        }//:Section
                    }
                }
                //:LazyVStack
            }//:VScrollView
            .toolbar {
                ToolbarItem {
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .onAppear {
                viewModel.getMyUserInfo()
            }
        }//:NavigationView
        .navigationViewStyle(.stack)
        .navigationBarTitleDisplayMode(.inline)
    }//:body
    
    var profileHeader: some View {
        ZStack {
            TopBannerView(imageUrl: viewModel.myUserInfo?.bannerImage, placeholderHexColor: viewModel.myUserInfo?.hexColor, height: bannerHeight)
                .frame(height: bannerHeight)
            
            VStack {
                CircleImageView(imageUrl: viewModel.myUserInfo?.avatar?.large, size: avatarSize)
                    .shadow(radius: 7)
                 
                 Text(viewModel.myUserInfo?.name ?? "")
                    .font(.title2)
                    .bold()
                    .frame(alignment: .center)
                    .transition(.move(edge: .top))
                
                /*Picker("Info type", selection: $infoType) {
                    ForEach(ProfileInfoType.allCases, id: \.self) { type in
                        Label(type.localizedName, systemImage: type.systemImage)
                    }
                }
                .pickerStyle(.segmented)
                .labelStyle(.iconOnly)
                .padding()*/
            }
            .padding(.top, 85)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
    }
}
