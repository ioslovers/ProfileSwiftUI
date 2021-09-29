//
//  ExperienceDetail.swift
//  Profile
//
//  Created by Ashish Tripathi on 14/9/21.
//

import SwiftUI


public struct ExperienceDetail : View {
    let experience: Experience
    public var body: some View {
        Spacer()
        VStack {
            HeaderView(name: "\(experience.role ?? "")",
                       iconName: experience.iconName ?? "",
                       description: "\(experience.experienceLabel ?? ""), \(experience.location ?? "")")
        }
        List {
            Section(header: Text("WORK SUMMARY")
            .multilineTextAlignment(.leading)
            .font(.footnote)) {
                Text(experience.workSummary ?? "")
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
            }
            
            Section(header: Text("Links")
                        .multilineTextAlignment(.leading)
                        .font(.footnote)) {
                ForEach(experience.links ?? []) { link in
                    LinkCell(link: link)
                }
            }
        }.navigationBarTitle(Text(experience.currentCompany ?? ""), displayMode: .inline)
    }
}
