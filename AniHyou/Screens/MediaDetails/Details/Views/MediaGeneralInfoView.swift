//
//  MediaGeneralInfoView.swift
//  AniHyou
//
//  Created by Axel Lopez on 2/7/22.
//

import SwiftUI

struct MediaGeneralInfoView: View {
    
    @ObservedObject var viewModel: MediaDetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Information")
                .font(.title3)
                .bold()
                .padding(.leading)
            HInfoView(name: "Genres", value: viewModel.genresFormatted, isExpandable: true)
            if viewModel.isAnime {
                HInfoView(name: "Episodes", value: viewModel.mediaDetails?.episodes?.formatted())
            } else {
                HInfoView(name: "Chapters", value: viewModel.mediaDetails?.chapters?.formatted())
                HInfoView(name: "Volumes", value: viewModel.mediaDetails?.volumes?.formatted())
            }
            HInfoView(name: "Start date", value: viewModel.mediaDetails?.startDate?.fragments.fuzzyDate.formatted())
            HInfoView(name: "End date", value: viewModel.mediaDetails?.endDate?.fragments.fuzzyDate.formatted())
            
            if viewModel.isAnime {
                HInfoView(name: "Season", value: viewModel.seasonFormatted)
                HInfoView(name: "Studios", value: viewModel.studiosFormatted, isExpandable: true)
                HInfoView(name: "Producers", value: viewModel.producersFormatted, isExpandable: true)
            }
            HInfoView(name: "Source", value: viewModel.mediaDetails?.source?.value?.localizedName)
            HInfoView(name: "Romaji", value: viewModel.mediaDetails?.title?.romaji, isExpandable: true)
            HInfoView(name: "English", value: viewModel.mediaDetails?.title?.english, isExpandable: true)
            HInfoView(name: "Native", value: viewModel.mediaDetails?.title?.native, isExpandable: true)
        }
    }
}

struct MediaGeneralInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MediaGeneralInfoView(viewModel: MediaDetailsViewModel())
    }
}
