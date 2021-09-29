//
//  Profile.swift
//  Profile
//
//  Created by Ashish Tripathi on 9/9/21.
//

import Foundation

// MARK: - Profile
public struct Profile: Codable, Identifiable {
    public let id: String?
    public let firstName, lastName, role, currentCompany: String?
    public let avatarName, professionalSummary: String?
    public let socialProfiles: [SocialProfile]?
    public let experiences: [Experience]?
    public let education: Education?
    public let skills: [Skills]?
    public var fullName: String? {
        get {
            guard let fName = firstName, let lName = lastName  else {
                return nil
            }
            return "\(fName) \(lName)"
        }
    }
}

// MARK: - Skills
public struct Skills: Codable, Identifiable {
    public let id: String?
    public let title: String?
    public let description: String?
}

// MARK: - Education
public struct Education: Codable, Identifiable {
    public let id: String?
    public let collegeName: String?
    public let year: String?
    public let degree: String?
}

// MARK: - Experience
public struct Experience: Codable, Identifiable {
    public let id: String?
    public let currentCompany: String?
    public let iconName: String?
    public let role: String?
    public let joiningDate: String?
    public let endDate: String?
    public let location: String?
    public let workSummary: String?
    public let isCurrentlyEmployed: String?
    public let links: [Link]?
    public var experienceLabel: String? {
        get {
            if isCurrentlyEmployed == "true" {
                return "\(joiningDate ?? "") to TILL NOW"
                    
            } else {
                return "\(joiningDate ?? "") to \(endDate ?? "")"
            }
        }
    }

}

// MARK: - Link
public struct Link: Codable, Identifiable {
    public let id: String?
    public let name: String
    public let link: String
}

// MARK: - Reference
public struct Reference: Codable {
    public let name: String?
    public let compnany: String?
    public let phone: String?
}

// MARK: - SocialProfile
public struct SocialProfile: Codable, Identifiable {
    public let id: String?
    public let domainName: String?
    public let url: String?
    public let iconName: String?
}

