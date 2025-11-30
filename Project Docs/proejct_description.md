# Project Description — iOS Cleaner App

## 1. Overview
iOS Cleaner — это мобильное приложение для очистки iPhone, ориентированное на массовую аудиторию из США, Японии и Бразилии.  
Приложение сочетает в себе высокую скорость работы, простой UX/UI, современный визуальный стиль и расширенный набор утилит: очистка фото/видео, управление контактами, компрессия видео, анализ батареи, секретный альбом, очистка email-спама и уникальная фича Smart Highlights Detector.

Проект создаётся полностью с помощью AI IDE (Google Antigravity / Cursor), основной UI-фреймворк — **SwiftUI**, архитектура — **MVVM + Services**, аналитика — **Firebase**.

---

## 2. Positioning & Value Proposition
Приложение позиционируется как:
- **Premium Cleaner Utility** с современным тёмным UI.
- Удобный и понятный инструмент для освобождения памяти.
- Продукт для массового трафика (TikTok Ads, UA постинг, серые воронки).
- Легковесное приложение, быстро выполняющее основные задачи.

### Ключевые преимущества:
- Высокое качество UX/UI (микс Premium Aurora Gradient + Modern iOS Dark).
- Уникальные фичи (Swipe-to-clean, Smart Highlights Detector, Video Compression).
- Сильные paywall-экраны с A/B тестами.
- Лёгкая архитектура и простой код (подходит для генерации ИИ).
- Friendly для App Store Review (без токсичных серых функций).

---

## 3. Target Audience
1. **США / Japan / Brazil** — активные пользователи iPhone.
2. Пользователи, у которых постоянно заканчивается память.
3. Люди, которые часто снимают фото/видео.
4. Владельцы дешёвых планов iCloud (50GB).
5. Неопытные пользователи, которым нужна простая очистка устройства.

---

## 4. Key Features (MVP Scope)

### 📸 Фото / Видео
- Duplicate Photos Detection  
- Similar Photos  
- Screenshots Cleaner  
- Live Photos Cleaner  
- Swipe-to-Clean (удаление свайпами)  
- Video Compression (архивация больших файлов)  
- **Smart Highlights Detector (AI-lite)** — выбор лучших фото по эвристикам

### 📞 Контакты
- Merge duplicate contacts  
- Remove empty contacts  
- Normalize phone formats  

### 📬 Почта
- Spam cleaner  
- Mass unsubscribe  
- Анализ отправителя  

### 🔋 Батарея
- Battery monitor  
- Battery usage tips  
- **Pseudo charging animations**

### 🔐 Secret Folder
- Secure vault for photos/videos 
- Secure vault for contacts
- Passcode lock  
- Biometric unlock  

### 🔔 Push Notifications
- Low storage alert  
- Duplicates found  
- Trial ending  
- Scan results  
- Reminder cleanups  

### 💰 Monetization
- Weekly plan: **$6.99**  
- Yearly plan: **$34.99**  
- Lifetime promo: **$29.99**  
- А/B тестирование paywalls  
- Ограниченный free режим: до **50 файлов** очистки в день  

---

## 5. Supported Languages
- English  
- Japanese  
- Portuguese (BR)  

---

## 6. Tech Stack

### Language & Frameworks
- **Swift 5+**
- **SwiftUI** (основной UI стек)
- **UIKit** (опционально, если потребуется)
- **Combine / ObservableObject / async/await**
- **PhotoKit**
- **Contacts Framework**
- **StoreKit 2**
- **UserNotifications**
- **LocalAuthentication**

### Services
- Firebase Analytics  
- Firebase Crashlytics  
- Firebase Firestore (логи + feature flags)  

---

## 7. Architecture

### Архитектурный паттерн
- **MVVM** для экранов  
- **Service Layer**:
  - PhotoService  
  - VideoService  
  - ContactsService  
  - MailService  
  - StorageService  
  - BatteryService  
  - SecretFolderService  
  - SubscriptionService (StoreKit 2)  
  - LogService (Firebase)  

### Data Flow
- UI → ViewModel → Service → Apple API (PhotoKit/Contacts)
- UI → ViewModel → StoreKit 2
- UI → ViewModel → Firestore (логирование)


### Локальные данные
- UserDefaults (настройки)  
- Secure Enclave (Secret Folder)  
- Lightweight caches (thumbnails, previews)  

---

## 8. App Structure (High-Level)

### Onboarding
1. Welcome  
2. Photo and Video cleaning intro  
3. Battery/Secret folder intro  
4. Paywall  

### Main App
- Dashboard: Photo / Video Cleaner (Duplicates, Similar, Screenshots, Live, Videos, Short Vedeos, Screen Recordings)
- Swipe Photo Cleaner
- Contacts Cleaner  
- Email Cleaner    
- More (Secret Folder, Device Health, Battery Life and Tips, Settings, Policies etc.) 

---

## 9. App Store Compliance Notes
- Не использовать термин “RAM cleaning”, “boost”, “instant speed”.  
- Только реальный доступ к фото/видео.  
- Псевдо-анимации должны называться “Creative Charging Screens”.  
- Никаких system-like popups.  
- Secret Folder должен использовать локальное шифрование (простой SecureEnclave).  

---

## 10. Approximate List of Tasks

## 🚧 Phase 1: Core Photo Cleaning (Priority: HIGH)

### Photo Analysis Engine
- [ ] Implement PhotoKit asset fetching
- [ ] Build duplicate detection algorithm
  - [ ] Image hashing (pHash or dHash)
  - [ ] Pixel-perfect comparison
  - [ ] EXIF metadata comparison
- [ ] Similar photos detection
  - [ ] Vision framework integration
  - [ ] Feature extraction
  - [ ] Similarity scoring
- [ ] Screenshot detection (mediaSubtypes)
- [ ] Live photos detection

### Photo Review UI
- [ ] DuplicatePhotosView
  - [ ] Grid/list of duplicate groups
  - [ ] Preview with comparison
  - [ ] Select/deselect interface
  - [ ] Batch delete confirmation
- [ ] SimilarPhotosView
  - [ ] Clustered groups
  - [ ] Smart selection (keep best)
  - [ ] Quality indicators
- [ ] ScreenshotsView
  - [ ] Date-based grouping
  - [ ] Quick preview
  - [ ] Mass delete option
- [ ] LivePhotosView
  - [ ] Convert to static option
  - [ ] Space savings preview

### Photo Services
- [ ] PhotoAnalysisService
  - [ ] Scanning progress tracking
  - [ ] Background processing
  - [ ] Cache results
- [ ] PhotoDeletionService
  - [ ] Batch delete with progress
  - [ ] Undo capability (trash)
  - [ ] Permission handling

---

## 🚧 Phase 2: Video Features (Priority: HIGH)

### Video Analysis
- [ ] Video asset fetching
- [ ] Short video detection (<20s)
- [ ] Screen recording detection

### Video Compression
- [ ] VideoCompressionService
  - [ ] Quality presets (High, Medium, Low)
  - [ ] Resolution downscaling
  - [ ] Bitrate optimization
  - [ ] Progress tracking
- [ ] Video compression UI
  - [ ] Size preview (before/after)
  - [ ] Quality comparison
  - [ ] Batch processing

### Video Review UI
- [ ] VideosView
  - [ ] Grid with thumbnails
  - [ ] Size/duration info
  - [ ] Compression options
- [ ] ShortVideosView
- [ ] ScreenRecordingsView

---

## 🚧 Phase 3: Swipe-to-Clean Feature (Priority: MEDIUM)

### Swipe Hub
- [ ] SwipeHubView
  - [ ] Category selection
  - [ ] Session stats
  - [ ] Start session CTA

### Swipe Session
- [ ] SwipeSessionView
  - [ ] Tinder-like card stack
  - [ ] Swipe gestures (left=delete, right=keep)
  - [ ] Undo last action
  - [ ] Progress indicator
  - [ ] Session completion summary
- [ ] SwipeSessionViewModel
  - [ ] Card queue management
  - [ ] Decision tracking
  - [ ] Batch operations

---

## 🚧 Phase 4: Contacts (Priority: MEDIUM)

### Contacts Cleanup
- [ ] Detect duplicate contacts (name / phone / email)
- [ ] Merge duplicates into a single clean contact
- [ ] Find contacts without a name / without a phone number
- [ ] Detect fully empty or broken contacts
- [ ] Bulk delete empty / useless contacts

### Contacts UX
- [ ] Contacts dashboard with categories (duplicates, no name, no number, empty, etc.)
- [ ] Duplicate groups with clear preview and choice of which contact to keep
- [ ] One-tap actions: “Delete all empty”, “Merge all duplicates (suggested)”
- [ ] Safe confirmation before bulk operations

### Secret Contacts
- [ ] Separate “Secret Contacts” section
- [ ] Add and store private contacts inside the app
- [ ] Protect access with PIN / Face ID
- [ ] Move a regular contact into Secret and back

### Permissions & Limits
- [ ] Request Contacts permission with a clear, human-friendly explanation
- [ ] Graceful fallback when permission is denied (blocking state with CTA to Settings)
- [ ] Free tier limit based on number of operations (merge/delete) before showing paywall


## 🚧 Phase 5: Email Cleanup (Priority: MEDIUM)

### Email Integration
- [ ] EmailService
  - [ ] Account connection (OAuth)
  - [ ] Inbox fetching
  - [ ] Spam detection
  - [ ] Newsletter detection

### Email UI
- [ ] EmailConnectView
  - [ ] Provider selection
  - [ ] OAuth flow
- [ ] EmailInboxCleanupView
  - [ ] Sender grouping
  - [ ] Mass unsubscribe
  - [ ] Delete suggestions

---

## 🚧 Phase 6: Secret Folder (Priority: MEDIUM)

### Security Setup
- [ ] SecretFolderService
  - [ ] Local encryption (Keychain)
  - [ ] Biometric authentication
  - [ ] PIN code fallback

### Secret Album
- [ ] SecretHomeView
  - [ ] Album grid
  - [ ] Add photos/videos
  - [ ] Remove items
- [ ] SecretAlbumView
  - [ ] Encrypted storage
  - [ ] Preview & playback
  - [ ] Export option

### Secret Contacts
- [ ] SecretContactsView
  - [ ] Hidden contacts list
  - [ ] Add from contacts
  - [ ] Call/message (with unlock)

---

## 🚧 Phase 7: Device Health & Battery (Priority: LOW)

### Battery Monitoring
- [ ] BatteryService
  - [ ] Battery level tracking
  - [ ] Battery health estimation
  - [ ] Charging state
  - [ ] Temperature monitoring (if available)

### Battery UI
- [ ] BatteryInsightsView
  - [ ] Health score
  - [ ] Usage tips
  - [ ] Charging animations (pseudo)
- [ ] DeviceHealthView
  - [ ] Storage breakdown
  - [ ] Battery status
  - [ ] System info

### System Tips
- [ ] SystemTipsView
  - [ ] Optimization suggestions
  - [ ] Quick actions

---

## 🚧 Phase 8: Settings & More (Priority: MEDIUM)

### Settings Screen
- [ ] SettingsView
  - [ ] Account/subscription status
  - [ ] Notification preferences
  - [ ] Language selection
  - [ ] Storage settings
  - [ ] About & support
  - [ ] Terms & privacy links

### Cleaning History
- [ ] CleaningHistoryService
  - [ ] Log cleanup sessions
  - [ ] Space freed tracking
- [ ] CleaningHistoryView
  - [ ] Timeline of cleanups
  - [ ] Stats & charts

---

## 🚧 Phase 9: Monetization & StoreKit (Priority: HIGH)

### Subscription System
- [ ] SubscriptionService
  - [ ] StoreKit 2 integration
  - [ ] Product fetching
  - [ ] Purchase flow
  - [ ] Receipt validation
  - [ ] Restore purchases
  - [ ] Subscription status sync

### Paywall Improvements
- [ ] A/B testing support
  - [ ] Multiple paywall variants
  - [ ] Feature flags integration
- [ ] Trial management
  - [ ] Trial countdown
  - [ ] Trial end notification
- [ ] Free tier limits
  - [ ] File count tracking
  - [ ] Limit enforcement
  - [ ] Upgrade prompts

---

## 🚧 Phase 10: Analytics & Firebase (Priority: HIGH)

### Firebase Integration
- [ ] Firebase SDK setup
- [ ] Firebase Analytics
  - [ ] Replace AnalyticsService placeholders
  - [ ] Custom events
  - [ ] User properties
- [ ] Firebase Crashlytics
  - [ ] Crash reporting
  - [ ] Custom logs
- [ ] Firebase Firestore
  - [ ] Feature flags
  - [ ] Remote config
  - [ ] User data sync (optional)

### Analytics Events
- [ ] Comprehensive event tracking
- [ ] Funnel analysis
- [ ] Retention tracking
- [ ] Revenue events

---

## 🚧 Phase 11: Push Notifications (Priority: MEDIUM)

### Notification System
- [ ] NotificationService
  - [ ] Local notifications
  - [ ] Remote notifications (Firebase)
  - [ ] Notification scheduling

### Notification Types
- [ ] Low storage alert
- [ ] Duplicates found
- [ ] Trial ending reminder
- [ ] Cleanup reminders
- [ ] Tips & tricks

---

## 🚧 Phase 12: Localization (Priority: MEDIUM)

### Languages
- [ ] English (base)
- [ ] Japanese
- [ ] Portuguese (BR)

### Localization Tasks
- [ ] Strings extraction
- [ ] Localizable.strings files
- [ ] Date/number formatting
- [ ] RTL support (if needed)
- [ ] Testing on all locales

---

## 🚧 Phase 13: Performance & Optimization (Priority: HIGH)

### Performance
- [ ] Photo loading optimization
  - [ ] Thumbnail caching
  - [ ] Lazy loading
  - [ ] Memory management
- [ ] Background processing
  - [ ] Photo analysis in background
  - [ ] Progress persistence
- [ ] App launch optimization
  - [ ] Reduce initialization time
  - [ ] Lazy service loading

### Testing
- [ ] Unit tests for services
- [ ] UI tests for critical flows
- [ ] Performance testing
- [ ] Memory leak detection

---

## 🚧 Phase 14: Polish & App Store Prep (Priority: HIGH)

### UI/UX Polish
- [ ] Animation refinements
- [ ] Loading states
- [ ] Error states
- [ ] Empty states
- [ ] Haptic feedback

### App Store Assets
- [ ] App icon design
- [ ] Screenshots (all locales)
- [ ] App preview video
- [ ] App Store description
- [ ] Keywords optimization
- [ ] Privacy policy
- [ ] Terms of service

### App Review Preparation
- [ ] Test account creation
- [ ] Review notes
- [ ] Compliance checklist
- [ ] Metadata review  

---

## 11. Goals for AI IDE
Этот документ служит основным контекстом для:
- генерации структуры проекта  
- создания экранов  
- генерации сервисов  
- построения навигации  
- создания подписочной логики  
- интеграции Firebase  
- генерации UI по стилю из ui_design.md  
- согласования фич с tasks.md  
