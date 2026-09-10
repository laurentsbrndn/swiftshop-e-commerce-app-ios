//
//  OrderViewModel.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 06/09/26.
//

import SwiftUI
internal import Combine

@MainActor
class TransactionHistoryViewModel: ObservableObject {
    @Published var orders: [OrderHistoryResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var selectedStatusFilter: String? = nil
    @Published var startDate: Date? = nil
    @Published var endDate: Date? = nil
    @Published var sortOption: SortOption = .newest
    
    enum SortOption: String, CaseIterable, Identifiable {
        case newest = "Newest"
        case oldest = "Oldest"
        case highest = "Highest Nominal"
        case lowest = "Lowest Nominal"
        var id: Self { self }
    }
    
    private let repository: OrderRepositoryProtocol
    
    init(repository: OrderRepositoryProtocol = OrderRepository()) {
        self.repository = repository
    }
    
    func fetchOrders(token: String?) async {
        guard let token = token, !token.isEmpty else {
            errorMessage = "Session is not valid. Please login again."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            orders = try await repository.fetchOrderHistory(token: token)
        } catch {
            print("❌ Order fetch error:", error)
            errorMessage = "Gagal memuat riwayat transaksi."
        }
        
        isLoading = false
    }
    
    func filteredAndSortedOrders(searchText: String) -> [OrderHistoryResponse] {
        var result = orders
        
        if let filter = selectedStatusFilter {
            result = result.filter { $0.status.lowercased() == filter.lowercased() }
        }
        
        if let start = startDate {
            result = result.filter { Calendar.current.startOfDay(for: $0.parsedDate) >= Calendar.current.startOfDay(for: start) }
        }
        if let end = endDate {
            if let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: end) {
                result = result.filter { $0.parsedDate <= endOfDay }
            }
        }
        
        if !searchText.isEmpty {
            result = result.filter { order in
                order.orderNumber.localizedCaseInsensitiveContains(searchText) ||
                order.items.contains { $0.productName.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        result.sort { lhs, rhs in
            switch sortOption {
            case .newest:
                return lhs.parsedDate > rhs.parsedDate
            case .oldest:
                return lhs.parsedDate < rhs.parsedDate
            case .highest:
                return lhs.totalAmount > rhs.totalAmount
            case .lowest:
                return lhs.totalAmount < rhs.totalAmount
            }
        }
        
        return result
    }
    
    func resetFilters() {
        selectedStatusFilter = nil
        startDate = nil
        endDate = nil
        sortOption = .newest
    }
}
