//
//  NotificationView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 09/09/26.
//


import SwiftUI

struct NotificationView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var viewModel = NotificationViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.notifications.isEmpty {
                ProgressView("Loading Notification")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage, viewModel.notifications.isEmpty {
                ErrorStateView(message: errorMessage) {
                    Task { await loadData() }
                }
            } else if viewModel.notifications.isEmpty {
                ContentUnavailableView(
                    "There are no notifications",
                    systemImage: "bell.slash",
                    description: Text("Order updates and important information will appear here.")
                )
            } else {
                List {
                    ForEach(viewModel.notifications) { notification in
                        NotificationRowView(notification: notification)
                            .padding(.vertical, 4)
                    }
                }
                .listStyle(.insetGrouped)
                .refreshable {
                    await loadData()
                }
            }
        }
        .navigationTitle("Notifications")
        .task {
            await loadData()
        }
        .onReceive(NotificationCenter.default.publisher(for: .checkoutDidSucceed)) { _ in
            Task.detached(priority: .userInitiated) {
                await viewModel.fetchNotifications(token: sessionManager.token)
            }
        }
    }
    
    private func loadData() async {
        await viewModel.fetchNotifications(token: sessionManager.token)
    }
}

struct NotificationRowView: View {
    let notification: NotificationResponse
    
    private var iconConfiguration: (name: String, color: Color) {
        if notification.type == "payment.succeeded" {
            return ("checkmark.circle.fill", .green)
        } else if notification.type.contains("cancel") || notification.type.contains("fail") {
            return ("xmark.circle.fill", .red)
        } else {
            return ("info.circle.fill", .blue)
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: iconConfiguration.name)
                .font(.title2)
                .foregroundStyle(iconConfiguration.color)
                .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    Text(notification.title)
                        .font(.headline)
                    Spacer()
                    Text(notification.parsedDate, format: .dateTime.day().month().hour().minute())
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                Text(notification.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .opacity(notification.status == "read" ? 0.6 : 1.0)
    }
}
