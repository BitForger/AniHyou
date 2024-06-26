//
//  ChartViewModel.swift
//  AniHyou
//
//  Created by Axel Lopez on 26/6/22.
//

import Foundation
import AniListAPI

@MainActor
class ChartViewModel: ObservableObject {

    private let perPage = 25

    @Published var mediaChart = [MediaChartQuery.Data.Page.Medium]()

    var currentPage = 1
    var hasNextPage = true

    func getMediaChart(
        type: MediaType,
        sort: MediaSort,
        status: MediaStatus?,
        format: MediaFormat? = nil
    ) async {
        if let result = await MediaRepository.getMediaChart(
            type: type,
            sort: sort,
            status: status,
            page: currentPage,
            perPage: perPage
        ) {
            mediaChart.append(contentsOf: result.data)
            currentPage = result.page
            // limit top 100 results
            if currentPage > 100 / perPage {
                hasNextPage = false
            } else {
                hasNextPage = result.hasNextPage
            }
        }
    }
}
