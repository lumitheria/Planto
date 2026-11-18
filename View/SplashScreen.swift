
import SwiftUI

// MARK: - Splash Screen
// تظهر عند كل تشغيل للتطبيق.
// تعرض اسم التطبيق وصورة النبتة لمدة قصيرة.
// بعدها تنتقل تلقائيًا إلى الشاشة المناسبة.

struct SplashScreen: View {

    // الدالة التي تنفذ بعد انتهاء شاشة البداية.
    let onFinish: () -> Void

    var body: some View {
        VStack(spacing: 20) {

            Spacer()

            // استخدام صورة Plant الموجودة في Assets.
            PlantIllustration(imageName: "Plant")

            // اسم التطبيق.
            Text("Planto")
                .font(
                    .system(
                        size: 36,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundStyle(.white)

            // وصف مختصر.
            Text("Your little plant companion")
                .font(.system(size: 15))
                .foregroundStyle(.gray)

            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(
            PlantTheme.background.ignoresSafeArea()
        )

        // عرض Splash لمدة 1.5 ثانية.
        .task {
            try? await Task.sleep(
                for: .seconds(1.5)
            )

            // عدم تنفيذ الانتقال إذا أُلغيت المهمة.
            guard !Task.isCancelled else {
                return
            }

            onFinish()
        }
    }
}

// MARK: - معاينة Splash Screen
#Preview {
    SplashScreen(onFinish: {})
}
