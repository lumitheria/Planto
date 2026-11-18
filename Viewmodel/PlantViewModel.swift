
import Foundation
import Combine
import UserNotifications

// MARK: - مدير بيانات النباتات وفق MVVM
// هذا الكلاس مسؤول عن منطق التطبيق وليس تصميم الواجهات.
// يتولى:
// 1. تحميل النباتات المحفوظة.
// 2. إضافة وتعديل وحذف النباتات.
// 3. تغيير حالة الري.
// 4. ترتيب النباتات وحساب نسبة الإنجاز.
// 5. حفظ البيانات محليًا.
// 6. جدولة الإشعارات اليومية.

@MainActor
final class PlantViewModel: ObservableObject {

    // قائمة النباتات التي تراقبها واجهات SwiftUI.
    // عند تغيرها يتم تحديث الواجهة تلقائيًا.
    @Published private(set) var plants: [PlantItem] = []

    // نستخدم نفس مفتاح التخزين القديم حتى لا تضيع النباتات المحفوظة.
    private let storageKey = "plantoPlantsCleanV1"

    // MARK: - بدء تشغيل مدير النباتات
    init() {
        load()
        refresh()

        // إعادة جدولة إشعارات النباتات الموجودة.
        for plant in plants {
            scheduleNotification(for: plant)
        }
    }

    // MARK: - بيانات مشتقة تستخدمها الواجهة

    // عدد النباتات التي تم ريها.
    var completedCount: Int {
        plants.filter { $0.isWatered }.count
    }

    // نسبة الإنجاز من 0 إلى 1.
    var progress: Double {
        guard !plants.isEmpty else { return 0 }
        return Double(completedCount) / Double(plants.count)
    }

    // هل تم ري جميع النباتات؟
    var allDone: Bool {
        !plants.isEmpty && completedCount == plants.count
    }

    // عرض النباتات المسقية أولًا، ثم غير المسقية.
    // نحافظ على ترتيب الإضافة داخل كل مجموعة.
    var sortedPlants: [PlantItem] {
        let watered = plants.filter { $0.isWatered }
        let unwatered = plants.filter { !$0.isWatered }
        return watered + unwatered
    }

    // MARK: - إضافة نبتة
    func add(_ plant: PlantItem) {
        plants.append(plant)
        save()
        scheduleNotification(for: plant)
    }

    // MARK: - تعديل نبتة
    // نبحث عن النبتة باستخدام ID ونحدث بياناتها.
    // تعمل العملية سواء كانت النبتة مسقية أو غير مسقية.
    func update(_ plant: PlantItem) {
        guard let index = plants.firstIndex(
            where: { $0.id == plant.id }
        ) else {
            return
        }

        plants[index] = plant
        save()
        scheduleNotification(for: plant)
    }

    // MARK: - حذف نبتة
    // نحذف النبتة من البيانات ونلغي إشعارها.
    func delete(_ plant: PlantItem) {
        plants.removeAll { $0.id == plant.id }
        save()

        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [plant.id.uuidString]
            )
    }

    // MARK: - تغيير حالة الري
    func toggle(_ plant: PlantItem) {
        guard let index = plants.firstIndex(
            where: { $0.id == plant.id }
        ) else {
            return
        }

        // عكس حالة الري الحالية.
        plants[index].isWatered.toggle()

        // إذا تم ري النبتة نحسب موعد الري القادم.
        if plants[index].isWatered {
            let days = plants[index].intervalDays

            plants[index].nextDue =
                Calendar.current.date(
                    byAdding: .day,
                    value: days,
                    to: Date()
                ) ?? Date().addingTimeInterval(
                    TimeInterval(days * 86400)
                )
        }

        save()
    }

    // MARK: - تحديث حالة الري
    // عند حلول موعد الري القادم، تعود النبتة إلى غير مسقية.
    func refresh() {
        let now = Date()
        var changed = false

        for index in plants.indices {
            if plants[index].isWatered &&
                plants[index].nextDue <= now {

                plants[index].isWatered = false
                changed = true
            }
        }

        if changed {
            save()
        }
    }

    // MARK: - حفظ البيانات
    // نحول النباتات إلى JSON ونحفظها في UserDefaults.
    private func save() {
        guard let data = try? JSONEncoder().encode(plants) else {
            return
        }

        UserDefaults.standard.set(data, forKey: storageKey)
    }

    // MARK: - تحميل البيانات
    // نقرأ النباتات المحفوظة عند تشغيل التطبيق.
    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let decoded = try? JSONDecoder().decode(
                [PlantItem].self,
                from: data
            )
        else {
            return
        }

        plants = decoded
    }

    // MARK: - طلب صلاحية الإشعارات
    func requestNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .badge, .sound]
            ) { [weak self] granted, error in

                if let error = error {
                    print(error.localizedDescription)
                }

                if granted {
                    Task { @MainActor in
                        guard let self = self else { return }

                        for plant in self.plants {
                            self.scheduleNotification(for: plant)
                        }
                    }
                }
            }
    }

    // MARK: - جدولة إشعار يومي لكل نبتة
    // الإشعار يتكرر كل يوم الساعة 9 صباحًا.
    // هذا يحافظ على سلوك الإشعارات في النسخة السابقة.
    private func scheduleNotification(for plant: PlantItem) {
        let center = UNUserNotificationCenter.current()
        let identifier = plant.id.uuidString

        // إزالة الإشعار القديم قبل إنشاء الجديد.
        center.removePendingNotificationRequests(
            withIdentifiers: [identifier]
        )

        // محتوى الإشعار.
        let content = UNMutableNotificationContent()
        content.title = "Planto"
        content.body = "Hey! let's water your plant"
        content.sound = .default

        // وقت الإشعار: 9:00 صباحًا.
        var date = DateComponents()
        date.hour = 9
        date.minute = 0

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: date,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
