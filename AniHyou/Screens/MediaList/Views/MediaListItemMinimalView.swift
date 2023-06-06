//
//  MediaListItemMinimalView.swift
//  AniHyou
//
//  Created by Axel Lopez on 14/01/2023.
//

import SwiftUI
import AniListAPI

struct MediaListItemMinimalView: View {
    
    var item: UserMediaListQuery.Data.Page.MediaList?
    @AppStorage(USER_SCORE_KEY) var scoreFormat: String = ScoreFormat.point100.rawValue
    var scoreFormatEnum: ScoreFormat {
        return ScoreFormat(rawValue: scoreFormat) ?? .point100
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item?.media?.title?.userPreferred ?? "Error loading item")
                .lineLimit(2)
            
            if item?.media?.nextAiringEpisode != nil {
                AiringScheduleItemText(item: item)
                    .padding(.top, 1)
            } else {
                Spacer()
            }
            
            HStack {
                Text("\(item?.progress ?? 0)/\(item?.totalProgress ?? 0)")
                Spacer()
                MediaListScoreIndicator(score: item?.score ?? 0, format: scoreFormatEnum)
            }
        }
        .padding(.vertical, 4)
    }
}

struct MediaListItemMinimalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List(0...4, id: \.self) { _ in
                NavigationLink(destination: {}) {
                    MediaListItemMinimalView()
                }
            }
        }
    }
}
