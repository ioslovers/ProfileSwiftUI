//
//  HeaderView.swift
//  Profile
//
//  Created by Ashish Tripathi on 14/9/21.
//

import SwiftUI

public struct HeaderView: View {
    public let name: String
    public let iconName: String
    public let description: String
    public var body: some View {
        VStack (alignment: .center, spacing: 4) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.orange, lineWidth: 4)
                )
                .shadow(radius: 10)
                .frame(width: 100.0, height: 100.0)
            Text(name)
                .font(.title)
                .multilineTextAlignment(.center)
            Text(description)
                .font(.footnote)
                .multilineTextAlignment(.center)
        }
    }
}

