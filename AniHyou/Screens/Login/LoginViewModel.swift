//
//  ProfileViewModel.swift
//  AniHyou
//
//  Created by Axel Lopez on 10/6/22.
//

import Foundation
import AuthenticationServices
import KeychainSwift

class LoginViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    
    private let clientId = Bundle.main.object(forInfoDictionaryKey: "ANILIST_CLIENT_ID") as? String ?? ""
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    @Published var isLoginSuccess = false
    
    func login() {
        let authSession = ASWebAuthenticationSession(url: URL(string: "\(ANILIST_AUTH_URL)?client_id=\(clientId)&response_type=token")!, callbackURLScheme: ANIHYOU_SCHEME) { [weak self] (url, error) in
            if let error = error {
                print(error)
                return
            } else if let url = url {
                self?.processResponseUrl(url: url)
            }
        }
        
        authSession.presentationContextProvider = self
        authSession.prefersEphemeralWebBrowserSession = true
        authSession.start()
    }
    
    /// Thanks to https://github.com/andyibanez
    private func processResponseUrl(url: URL) {
        let anilistComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        // Anilist actually returns the token in a messed up way.
        // All the parameters - including query parameters - are AFTER the fragment.
        // So I can't just access the query property of these components to get all the data I need.
        // To work around this and save myself the headache of possible encoding issues, I will create
        // a new URL using the fragment of the old components and some dummy domain.
        
        if let anilistFragment = anilistComponents?.fragment,
           let dummyURL = URL(string: "http://dummyurl.com?\(anilistFragment)"),
           let components = URLComponents(url: dummyURL, resolvingAgainstBaseURL: true),
           let queryItems = components.queryItems,
           let token = queryItems.filter ({ $0.name == "access_token" }).first?.value,
           let expirationDate = queryItems.filter ({ $0.name == "expires_in" }).first?.value {
            KeychainSwift().set(token, forKey: USER_TOKEN_KEY)
            UserDefaults.standard.set(expirationDate, forKey: "token_expiration")
            UserDefaults.standard.set(true, forKey: "is_logged_in")
            getUserIdAndOptions()
            self.isLoginSuccess = true
        }
    }
    
    private func getUserIdAndOptions() {
        Network.shared.apollo.fetch(query: ViewerIdQuery()) { result in
            switch result {
            case .success(let graphQLResult):
                if let viewer = graphQLResult.data?.viewer {
                    UserDefaults.standard.set(viewer.id, forKey: USER_ID_KEY)
                    UserDefaults.standard.set(viewer.options?.profileColor, forKey: USER_COLOR_KEY)
                    UserDefaults.standard.set(viewer.options?.staffNameLanguage?.value?.rawValue, forKey: USER_NAMES_LANG_KEY)
                    UserDefaults.standard.set(viewer.options?.titleLanguage?.value?.rawValue, forKey: USER_TITLE_LANG_KEY)
                    UserDefaults.standard.set(viewer.mediaListOptions?.scoreFormat?.value?.rawValue, forKey: USER_SCORE_KEY)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
