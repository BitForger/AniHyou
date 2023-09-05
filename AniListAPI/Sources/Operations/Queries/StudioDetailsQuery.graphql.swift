// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class StudioDetailsQuery: GraphQLQuery {
  public static let operationName: String = "StudioDetails"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query StudioDetails($studioId: Int, $page: Int, $perPage: Int) { Studio(id: $studioId) { __typename id name favourites ...IsFavouriteStudio media(isMain: true, page: $page, perPage: $perPage, sort: [START_DATE_DESC]) { __typename nodes { __typename id coverImage { __typename large } title { __typename userPreferred } type mediaListEntry { __typename status } } pageInfo { __typename hasNextPage } } } }"#,
      fragments: [IsFavouriteStudio.self]
    ))

  public var studioId: GraphQLNullable<Int>
  public var page: GraphQLNullable<Int>
  public var perPage: GraphQLNullable<Int>

  public init(
    studioId: GraphQLNullable<Int>,
    page: GraphQLNullable<Int>,
    perPage: GraphQLNullable<Int>
  ) {
    self.studioId = studioId
    self.page = page
    self.perPage = perPage
  }

  public var __variables: Variables? { [
    "studioId": studioId,
    "page": page,
    "perPage": perPage
  ] }

  public struct Data: AniListAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { AniListAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("Studio", Studio?.self, arguments: ["id": .variable("studioId")]),
    ] }

    /// Studio query
    public var studio: Studio? { __data["Studio"] }

    /// Studio
    ///
    /// Parent Type: `Studio`
    public struct Studio: AniListAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { AniListAPI.Objects.Studio }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", Int.self),
        .field("name", String.self),
        .field("favourites", Int?.self),
        .field("media", Media?.self, arguments: [
          "isMain": true,
          "page": .variable("page"),
          "perPage": .variable("perPage"),
          "sort": ["START_DATE_DESC"]
        ]),
        .fragment(IsFavouriteStudio.self),
      ] }

      /// The id of the studio
      public var id: Int { __data["id"] }
      /// The name of the studio
      public var name: String { __data["name"] }
      /// The amount of user's who have favourited the studio
      public var favourites: Int? { __data["favourites"] }
      /// The media the studio has worked on
      public var media: Media? { __data["media"] }
      /// If the studio is marked as favourite by the currently authenticated user
      public var isFavourite: Bool { __data["isFavourite"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public var isFavouriteStudio: IsFavouriteStudio { _toFragment() }
      }

      /// Studio.Media
      ///
      /// Parent Type: `MediaConnection`
      public struct Media: AniListAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { AniListAPI.Objects.MediaConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
          .field("pageInfo", PageInfo?.self),
        ] }

        public var nodes: [Node?]? { __data["nodes"] }
        /// The pagination information
        public var pageInfo: PageInfo? { __data["pageInfo"] }

        /// Studio.Media.Node
        ///
        /// Parent Type: `Media`
        public struct Node: AniListAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { AniListAPI.Objects.Media }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", Int.self),
            .field("coverImage", CoverImage?.self),
            .field("title", Title?.self),
            .field("type", GraphQLEnum<AniListAPI.MediaType>?.self),
            .field("mediaListEntry", MediaListEntry?.self),
          ] }

          /// The id of the media
          public var id: Int { __data["id"] }
          /// The cover images of the media
          public var coverImage: CoverImage? { __data["coverImage"] }
          /// The official titles of the media in various languages
          public var title: Title? { __data["title"] }
          /// The type of the media; anime or manga
          public var type: GraphQLEnum<AniListAPI.MediaType>? { __data["type"] }
          /// The authenticated user's media list entry for the media
          public var mediaListEntry: MediaListEntry? { __data["mediaListEntry"] }

          /// Studio.Media.Node.CoverImage
          ///
          /// Parent Type: `MediaCoverImage`
          public struct CoverImage: AniListAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { AniListAPI.Objects.MediaCoverImage }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("large", String?.self),
            ] }

            /// The cover image url of the media at a large size
            public var large: String? { __data["large"] }
          }

          /// Studio.Media.Node.Title
          ///
          /// Parent Type: `MediaTitle`
          public struct Title: AniListAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { AniListAPI.Objects.MediaTitle }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("userPreferred", String?.self),
            ] }

            /// The currently authenticated users preferred title language. Default romaji for non-authenticated
            public var userPreferred: String? { __data["userPreferred"] }
          }

          /// Studio.Media.Node.MediaListEntry
          ///
          /// Parent Type: `MediaList`
          public struct MediaListEntry: AniListAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { AniListAPI.Objects.MediaList }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("status", GraphQLEnum<AniListAPI.MediaListStatus>?.self),
            ] }

            /// The watching/reading status
            public var status: GraphQLEnum<AniListAPI.MediaListStatus>? { __data["status"] }
          }
        }

        /// Studio.Media.PageInfo
        ///
        /// Parent Type: `PageInfo`
        public struct PageInfo: AniListAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { AniListAPI.Objects.PageInfo }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("hasNextPage", Bool?.self),
          ] }

          /// If there is another page
          public var hasNextPage: Bool? { __data["hasNextPage"] }
        }
      }
    }
  }
}
