import Foundation
import StoreKit

/// Сервис управления подписками (StoreKit 2)
@MainActor
final class SubscriptionService: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = SubscriptionService()
    
    // MARK: - Product IDs
    
    private let weeklyProductID = "com.cleaner.subscription.weekly"
    private let yearlyProductID = "com.cleaner.subscription.yearly"
    private let lifetimeProductID = "com.cleaner.lifetime"
    
    // MARK: - Published Properties
    
    @Published var products: [Product] = []
    @Published var purchasedProductIDs: Set<String> = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Computed Properties
    
    var weeklyProduct: Product? {
        products.first { $0.id == weeklyProductID }
    }
    
    var yearlyProduct: Product? {
        products.first { $0.id == yearlyProductID }
    }
    
    var lifetimeProduct: Product? {
        products.first { $0.id == lifetimeProductID }
    }
    
    var hasActiveSubscription: Bool {
        !purchasedProductIDs.isEmpty
    }
    
    // MARK: - Init
    
    private init() {
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
        
        // Listen for transaction updates
        startTransactionListener()
    }
    
    // MARK: - Load Products
    
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let productIDs = [weeklyProductID, yearlyProductID, lifetimeProductID]
            products = try await Product.products(for: productIDs)
            isLoading = false
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
            isLoading = false
            
            #if DEBUG
            print("❌ StoreKit Error: \(error)")
            #endif
        }
    }
    
    // MARK: - Purchase
    
    func purchase(_ product: Product) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try Self.checkVerified(verification)
                await updatePurchasedProducts()
                await transaction.finish()
                
                isLoading = false
                
                AnalyticsService.shared.logPaywallPurchaseSuccess(
                    plan: product.id,
                    price: product.displayPrice
                )
                
                // Update app state
                AppState.shared.updateSubscriptionStatus(.premium)
                
                return true
                
            case .userCancelled:
                isLoading = false
                return false
                
            case .pending:
                isLoading = false
                errorMessage = "Purchase is pending approval"
                return false
                
            @unknown default:
                isLoading = false
                return false
            }
        } catch {
            isLoading = false
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            
            AnalyticsService.shared.logPaywallPurchaseFail(error: error.localizedDescription)
            
            return false
        }
    }
    
    // MARK: - Restore Purchases
    
    func restorePurchases() async {
        isLoading = true
        
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
            isLoading = false
            
            if hasActiveSubscription {
                AppState.shared.updateSubscriptionStatus(.premium)
            }
        } catch {
            isLoading = false
            errorMessage = "Failed to restore purchases: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Private Methods
    
    private func updatePurchasedProducts() async {
        var purchased: Set<String> = []
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try Self.checkVerified(result)
                purchased.insert(transaction.productID)
            } catch {
                continue
            }
        }
        
        purchasedProductIDs = purchased
        
        // Update app state based on subscription
        if !purchased.isEmpty {
            AppState.shared.updateSubscriptionStatus(.premium)
        }
    }
    
    private func startTransactionListener() {
        Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try Self.checkVerified(result)
                    await self.handleTransactionUpdate()
                    await transaction.finish()
                } catch {
                    continue
                }
            }
        }
    }
    
    private func handleTransactionUpdate() async {
        await updatePurchasedProducts()
    }
    
    // Static helper - can be called from any context
    private nonisolated static func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreKitError.notAvailableInStorefront
        case .verified(let safe):
            return safe
        }
    }
}
