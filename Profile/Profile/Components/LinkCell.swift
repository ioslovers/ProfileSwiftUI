//
//  LinkCell.swift
//  Profile
//
//  Created by Ashish Tripathi on 21/9/21.
//

import SwiftUI

public struct LinkCell : View {
    let link: Link
    public var body: some View {
        return NavigationLink(destination:  WebView(request: URLRequest(url: URL(string: link.link )!))) {
            VStack(alignment: .leading) {
                Text(link.name)
                Text(link.link)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
