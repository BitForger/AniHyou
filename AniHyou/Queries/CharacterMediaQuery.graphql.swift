// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import API

public class CharacterMediaQuery: GraphQLQuery {
  public static let operationName: String = "CharacterMedia"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      query CharacterMedia($characterId: Int, $page: Int, $perPage: Int) {
        Character(id: $characterId) {
          __typename
          media(page: $page, perPage: $perPage, sort: [POPULARITY_DESC]) {
            __typename
            edges {
              __typename
              id
              node {
                __typename
                id
                title {
                  __typename
                  userPreferred
                }
                coverImage {
                  __typename
                  large
                }
              }
              characterName
              characterRole
              voiceActors(sort: [RELEVANCE, LANGUAGE]) {
                __typename
                id
                name {
                  __typename
                  userPreferred
                }
                languageV2
              }
            }
            pageInfo {
              __typename
              currentPage
              hasNextPage
            }
          }
        }
      }
      """#
    ))

  public var characterId: GraphQLNullable<Int>
  public var page: GraphQLNullable<Int>
  public var perPage: GraphQLNullable<Int>

  public init(
    characterId: GraphQLNullable<Int>,
    page: GraphQLNullable<Int>,
    perPage: GraphQLNullable<Int>
  ) {
    self.characterId = characterId
    self.page = page
    self.perPage = perPage
  }

  public var __variables: Variables? { [
    "characterId": characterId,
    "page": page,
    "perPage": perPage
  ] }

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { API.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("Character", Character?.self, arguments: ["id": .variable("characterId")]),
    ] }

    /// Character query
    public var character: Character? { __data["Character"] }

    /// Character
    ///
    /// Parent Type: `Character`
    public struct Character: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Character }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("media", Media?.self, arguments: [
          "page": .variable("page"),
          "perPage": .variable("perPage"),
          "sort": ["POPULARITY_DESC"]
        ]),
      ] }

      /// Media that includes the character
      public var media: Media? { __data["media"] }

      /// Character.Media
      ///
      /// Parent Type: `MediaConnection`
      public struct Media: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.MediaConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("edges", [Edge?]?.self),
          .field("pageInfo", PageInfo?.self),
        ] }

        public var edges: [Edge?]? { __data["edges"] }
        /// The pagination information
        public var pageInfo: PageInfo? { __data["pageInfo"] }

        /// Character.Media.Edge
        ///
        /// Parent Type: `MediaEdge`
        public struct Edge: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.MediaEdge }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", Int?.self),
            .field("node", Node?.self),
            .field("characterName", String?.self),
            .field("characterRole", GraphQLEnum<API.CharacterRole>?.self),
            .field("voiceActors", [VoiceActor?]?.self, arguments: ["sort": ["RELEVANCE", "LANGUAGE"]]),
          ] }

          /// The id of the connection
          public var id: Int? { __data["id"] }
          public var node: Node? { __data["node"] }
          /// Media specific character name
          public var characterName: String? { __data["characterName"] }
          /// The characters role in the media
          public var characterRole: GraphQLEnum<API.CharacterRole>? { __data["characterRole"] }
          /// The voice actors of the character
          public var voiceActors: [VoiceActor?]? { __data["voiceActors"] }

          /// Character.Media.Edge.Node
          ///
          /// Parent Type: `Media`
          public struct Node: API.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { API.Objects.Media }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", Int.self),
              .field("title", Title?.self),
              .field("coverImage", CoverImage?.self),
            ] }

            /// The id of the media
            public var id: Int { __data["id"] }
            /// The official titles of the media in various languages
            public var title: Title? { __data["title"] }
            /// The cover images of the media
            public var coverImage: CoverImage? { __data["coverImage"] }

            /// Character.Media.Edge.Node.Title
            ///
            /// Parent Type: `MediaTitle`
            public struct Title: API.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { API.Objects.MediaTitle }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("userPreferred", String?.self),
              ] }

              /// The currently authenticated users preferred title language. Default romaji for non-authenticated
              public var userPreferred: String? { __data["userPreferred"] }
            }

            /// Character.Media.Edge.Node.CoverImage
            ///
            /// Parent Type: `MediaCoverImage`
            public struct CoverImage: API.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { API.Objects.MediaCoverImage }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("large", String?.self),
              ] }

              /// The cover image url of the media at a large size
              public var large: String? { __data["large"] }
            }
          }

          /// Character.Media.Edge.VoiceActor
          ///
          /// Parent Type: `Staff`
          public struct VoiceActor: API.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { API.Objects.Staff }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", Int.self),
              .field("name", Name?.self),
              .field("languageV2", String?.self),
            ] }

            /// The id of the staff member
            public var id: Int { __data["id"] }
            /// The names of the staff member
            public var name: Name? { __data["name"] }
            /// The primary language of the staff member. Current values: Japanese, English, Korean, Italian, Spanish, Portuguese, French, German, Hebrew, Hungarian, Chinese, Arabic, Filipino, Catalan, Finnish, Turkish, Dutch, Swedish, Thai, Tagalog, Malaysian, Indonesian, Vietnamese, Nepali, Hindi, Urdu
            public var languageV2: String? { __data["languageV2"] }

            /// Character.Media.Edge.VoiceActor.Name
            ///
            /// Parent Type: `StaffName`
            public struct Name: API.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { API.Objects.StaffName }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("userPreferred", String?.self),
              ] }

              /// The currently authenticated users preferred name language. Default romaji for non-authenticated
              public var userPreferred: String? { __data["userPreferred"] }
            }
          }
        }

        /// Character.Media.PageInfo
        ///
        /// Parent Type: `PageInfo`
        public struct PageInfo: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.PageInfo }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("currentPage", Int?.self),
            .field("hasNextPage", Bool?.self),
          ] }

          /// The current page
          public var currentPage: Int? { __data["currentPage"] }
          /// If there is another page
          public var hasNextPage: Bool? { __data["hasNextPage"] }
        }
      }
    }
  }
}