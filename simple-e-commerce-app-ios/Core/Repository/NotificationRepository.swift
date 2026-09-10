//
//  NotificationRepository.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 09/09/26.
//

import Foundation

protocol NotificationRepositoryProtocol {
    func fetchNotifications(token: String?) async throws -> [NotificationResponse]
}

struct NotificationRepository: NotificationRepositoryProtocol {
    func fetchNotifications(token: String? = nil) async throws -> [NotificationResponse] {
        let endpoint = APIEndpoints.Notification.get()
        
        let response: PagedResponse<NotificationResponse> = try await APIClient.shared.request(
            url: endpoint,
            token: token
        )
        return response.items
    }
}
