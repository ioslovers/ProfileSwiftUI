//
//  ExperienceCell.swift
//  Profile
//
//  Created by Ashish Tripathi on 14/9/21.
//

import SwiftUI

public struct ExperienceCell : View {
    let experience: Experience
    public var body: some View {
        NavigationLink(destination: ExperienceDetail(experience: experience)) {
            Image(experience.iconName ?? "")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .cornerRadius(40)
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(experience.currentCompany ?? "")
                Text(experience.location ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(experience.experienceLabel ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
