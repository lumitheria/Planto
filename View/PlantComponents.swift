
import SwiftUI

// MARK: - ألوان التطبيق المشتركة
// استخدام الألوان من ملف واحد يمنع اختلاف درجاتها بين الصفحات.

enum PlantTheme {

    // خلفية التطبيق.
    static let background = Color.black

    // الأخضر الأساسي لشريط التقدم وعلامة الصح.
    static let green = Color(
        red: 0.18,
        green: 0.58,
        blue: 0.47
    )

    // الأخضر الفاتح المستخدم في تدرج الأزرار.
    static let greenHighlight = Color(
        red: 0.37,
        green: 0.75,
        blue: 0.63
    )

    // لون معلومات الإضاءة.
    static let yellow = Color(
        red: 0.94,
        green: 0.84,
        blue: 0.39
    )

    // لون معلومات الماء.
    static let blue = Color(
        red: 0.67,
        green: 0.85,
        blue: 0.94
    )

    // خلفية معلومات النبتة.
    static let tag = Color(
        red: 0.12,
        green: 0.13,
        blue: 0.15
    )

    // الخط الفاصل.
    static let separator = Color.white.opacity(0.16)

    // حركة ناعمة عند تغيير حالة الري.
    static let animation = Animation.spring(
        response: 0.38,
        dampingFraction: 0.86
    )

    // تدرج الأزرار.
    static let buttonGradient = LinearGradient(
        colors: [
            greenHighlight,
            green
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - المكون المشترك لصور النباتات
// نستعمل نفس المقاس للصورتين في البداية والنهاية.
// التمركز العمودي تحدده الصفحات التي تستخدم هذا المكون.

struct PlantIllustration: View {

    // اسم الصورة داخل Assets.
    let imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 180, height: 205)
            .frame(maxWidth: .infinity)
    }
}

// MARK: - عنوان التطبيق المشترك
// يظهر في صفحة الترحيب وصفحة النباتات.

struct PlantsHeader: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {

            Text("My Plants 🌱")
                .font(.system(size: 31, weight: .bold))
                .foregroundStyle(.white)

            Rectangle()
                .fill(PlantTheme.separator)
                .frame(height: 0.5)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}
