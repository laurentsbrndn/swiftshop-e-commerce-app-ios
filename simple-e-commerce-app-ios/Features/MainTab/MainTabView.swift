import SwiftUI

enum AppTab: Int, CaseIterable, Identifiable {
    case product
    case cart
    case history
    case notification
    case profile
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .product: return "Catalog"
        case .cart: return "Cart"
        case .history: return "History"
        case .notification: return "Notification"
        case .profile: return "Profile"
        }
    }
    
    var iconName: String {
        switch self {
        case .product: return "bag"
        case .cart: return "cart"
        case .history: return "clock.arrow.circlepath"
        case .notification: return "bell"
        case .profile: return "person"
        }
    }
    
    var selectedIconName: String {
        switch self {
        case .product: return "bag.fill"
        case .cart: return "cart.fill"
        case .history: return "clock.arrow.circlepath"
        case .notification: return "bell.fill"
        case .profile: return "person.fill"
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab: AppTab = .product
    @StateObject private var cartViewModel = CartViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                ProductListView()
            }
            .tabItem { Label(AppTab.product.title, systemImage: selectedTab == .product ? AppTab.product.selectedIconName : AppTab.product.iconName) }
            .tag(AppTab.product)
            
            NavigationStack {
                CartView()
            }
            .tabItem { Label(AppTab.cart.title, systemImage: selectedTab == .cart ? AppTab.cart.selectedIconName : AppTab.cart.iconName) }
            .tag(AppTab.cart)
            
            NavigationStack {
                TransactionHistoryView()
            }
            .tabItem { Label(AppTab.history.title, systemImage: selectedTab == .history ? AppTab.history.selectedIconName : AppTab.history.iconName) }
            .tag(AppTab.history)
            
            NavigationStack {
                NotificationView()
            }
            .tabItem { Label(AppTab.notification.title, systemImage: selectedTab == .notification ? AppTab.notification.selectedIconName : AppTab.notification.iconName) }
            .tag(AppTab.notification)
            
            NavigationStack {
                ProfileView()
            }
            .tabItem { Label(AppTab.profile.title, systemImage: selectedTab == .profile ? AppTab.profile.selectedIconName : AppTab.profile.iconName) }
            .tag(AppTab.profile)
        }
        .environmentObject(cartViewModel)
    }
}
