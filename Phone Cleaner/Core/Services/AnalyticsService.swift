import Foundation

/// Сервис аналитики (заглушка для Firebase Analytics)
/// В будущем заменить на реальную интеграцию с Firebase
final class AnalyticsService {
    
    // MARK: - Singleton
    
    static let shared = AnalyticsService()
    
    private init() {}
    
    // MARK: - Events
    
    /// Логирование события
    func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        #if DEBUG
        print("📊 Analytics Event: \(name)")
        if let params = parameters {
            print("   Parameters: \(params)")
        }
        #endif
        
        // TODO: Firebase.Analytics.logEvent(name, parameters: parameters)
    }
    
    // MARK: - Onboarding Events
    
    func logOnboardingStepShown(step: Int) {
        logEvent("onboarding_step_\(step)_shown")
    }
    
    func logOnboardingStepNext(step: Int) {
        logEvent("onboarding_step_\(step)_next_tap")
    }
    
    func logOnboardingPermissionRequest() {
        logEvent("onboarding_permission_request")
    }
    
    func logOnboardingPermissionGranted() {
        logEvent("onboarding_permission_granted")
    }
    
    func logOnboardingPermissionDenied() {
        logEvent("onboarding_permission_denied")
    }
    
    // MARK: - Dashboard Events
    
    func logDashboardOpen() {
        logEvent("dashboard_open")
    }
    
    func logDashboardCategoryTap(category: String) {
        logEvent("dashboard_category_tap", parameters: ["category": category])
    }
    
    func logDashboardTrialCTATap() {
        logEvent("dashboard_trial_cta_tap")
    }
    
    // MARK: - Paywall Events
    
    func logPaywallShown(source: String, variant: String = "A") {
        logEvent("paywall_shown", parameters: [
            "source": source,
            "variant": variant
        ])
    }
    
    func logPaywallPlanSelected(plan: String) {
        logEvent("paywall_plan_selected", parameters: ["plan": plan])
    }
    
    func logPaywallPurchaseSuccess(plan: String, price: String) {
        logEvent("paywall_purchase_success", parameters: [
            "plan": plan,
            "price": price
        ])
    }
    
    func logPaywallPurchaseFail(error: String) {
        logEvent("paywall_purchase_fail", parameters: ["error": error])
    }
    
    func logPaywallSkip() {
        logEvent("paywall_skip")
    }
    
    // MARK: - Photo Events
    
    func logDuplicatePhotosOpen() {
        logEvent("dup_photos_open")
    }
    
    func logDuplicateDeleteConfirm(count: Int, size: Int64) {
        logEvent("dup_delete_confirm", parameters: [
            "count": count,
            "size_bytes": size
        ])
    }
    
    func logDuplicateDeleteSuccess(count: Int, size: Int64) {
        logEvent("dup_delete_success", parameters: [
            "count": count,
            "size_bytes": size
        ])
    }
    
    // MARK: - Contacts Events
    
    func logContactsCleanerOpened() {
        logEvent("contacts_cleaner_opened")
    }
    
    func logContactsMerge(count: Int) {
        logEvent("contacts_merge_completed", parameters: ["count": count])
    }
    
    func logContactsDelete(count: Int) {
        logEvent("contacts_bulk_delete", parameters: ["count": count])
    }
    
    // MARK: - Swipe Events
    
    func logSwipeHubOpen() {
        logEvent("swipe_hub_open")
    }
    
    func logSwipeSessionStart(month: String) {
        logEvent("swipe_session_start", parameters: ["month": month])
    }
    
    func logSwipeSessionComplete(kept: Int, deleted: Int) {
        logEvent("swipe_session_complete", parameters: [
            "kept": kept,
            "deleted": deleted
        ])
    }
    
    // MARK: - Settings Events
    
    func logSettingsOpen() {
        logEvent("settings_open")
    }
    
    func logSecretSpaceOpen() {
        logEvent("secret_space_open")
    }
}

