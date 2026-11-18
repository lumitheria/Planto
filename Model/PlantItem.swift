import Foundation

// MARK: - نموذج بيانات النبتة
// هذا الملف يحتوي على شكل بيانات النبتة فقط.
// لا يحتوي على تصميم واجهات أو عمليات حفظ وإشعارات.

struct PlantItem: Identifiable, Codable, Equatable {

    // رقم فريد لكل نبتة حتى نقدر نميزها عند التعديل والحذف.
    var id: UUID = UUID()

    // اسم النبتة.
    var name: String

    // الغرفة التي توجد فيها النبتة.
    var room: String

    // كمية الإضاءة المناسبة.
    var light: String

    // الفترة بين كل عملية ري.
    var wateringDays: String

    // كمية الماء المطلوبة.
    var water: String

    // هل تم ري النبتة؟
    var isWatered: Bool = false

    // الموعد القادم الذي تصبح فيه النبتة بحاجة للري.
    var nextDue: Date = Date()

    // MARK: - تحويل فترة الري إلى عدد أيام
    // نستخدم هذه القيمة لحساب موعد الري القادم.
    var intervalDays: Int {
        switch wateringDays {
        case "Every 2 days":
            return 2
        case "Every 3 days":
            return 3
        case "Once a week":
            return 7
        case "Every 10 days":
            return 10
        case "Every 2 weeks":
            return 14
        default:
            return 1
        }
    }
}


