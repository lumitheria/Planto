
import SwiftUI

// MARK: - Splash Screen
// تظهر عند تشغيل التطبيق لمدة 1.5 ثانية.
// بعدها ينتقل التطبيق تلقائيًا حسب حالة المستخدمة.

struct SplashScreen: View {

    // تنفذ بعد انتهاء عرض Splash.
    let onFinish: () -> Void

    var body: some View {
        VStack(spacing: 20) {

            Spacer()

            // صورة النبتة الموجودة في Assets.
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
        .task {
            // الانتظار لمدة 1.5 ثانية.
            try? await Task.sleep(for: .seconds(1.5))

            // منع الانتقال إذا أُلغيت المهمة.
            guard !Task.isCancelled else {
                return
            }

            onFinish()
        }
    }
}

#Preview {
    SplashScreen(onFinish: {})
}
