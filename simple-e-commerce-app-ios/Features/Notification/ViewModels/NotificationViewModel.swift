//
//  NotificationViewModel.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 09/09/26.
//


import SwiftUI
internal import Combine

@MainActor
class NotificationViewModel: ObservableObject {
    @Published var notifications: [NotificationResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: NotificationRepositoryProtocol
    private var fetchTask: Task<Void, Never>?
    
    init(repository: NotificationRepositoryProtocol = NotificationRepository()) {
        self.repository = repository
    }
    
    func fetchNotifications(token: String?) async {
        guard let token = token, !token.isEmpty else {
            errorMessage = "Sesi tidak valid. Silakan login kembali."
            return
        }
        
        fetchTask?.cancel()
        
        fetchTask = Task {
            if notifications.isEmpty {
                isLoading = true
            }
            errorMessage = nil
            
            do {
                let items = try await repository.fetchNotifications(token: token)
                if !Task.isCancelled {
                    self.notifications = items
                    self.isLoading = false
                }
            } catch {
                if !Task.isCancelled {
                    let nsError = error as NSError
                    if nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorCancelled {
                        return
                    }
                    
                    print("❌ Notification fetch error:", error)
                    self.errorMessage = "Gagal memuat notifikasi."
                    self.isLoading = false
                }
            }
        }
        
        await fetchTask?.value
    }
}
