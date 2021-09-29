//
//  SocialCell.swift
//  Profile
//
//  Created by Ashish Tripathi on 14/9/21.
//

import SwiftUI

public struct SocialCell : View {
    let social: SocialProfile
    public var body: some View {
        return NavigationLink(destination:  WebView(request: URLRequest(url: URL(string: social.url ?? "")!))) {
            Image(social.iconName ?? "")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .cornerRadius(40)
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(social.domainName ?? "")
                Text(social.url ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
