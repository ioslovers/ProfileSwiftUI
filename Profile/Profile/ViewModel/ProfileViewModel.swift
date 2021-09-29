//
//  ProfileViewModel.swift
//  Profile
//
//  Created by Ashish Tripathi on 9/9/21.
//

import Foundation
import Combine

public class ProfileViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published public var profile: Profile?
    @Published public var apiError: Error?
    
    func getProfileDetails() {
        Networking.shared.getData(endpoint: .profile,type: Profile.self)
            .sink { [weak self] error in
                guard let self = self else { return }
                switch error {
                case let .failure(failedError):
                    self.apiError = failedError
                case .finished:
                    self.apiError = nil
                }
            } receiveValue: { [weak self] profileDetails in
                guard let self = self else { return }
                self.profile = profileDetails
            }
            .store(in: &cancellables)
    }
    
    func retry() {
        apiError = nil
        getProfileDetails()
    }
}
