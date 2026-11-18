
import SwiftUI

// MARK: - الشاشة الرئيسية للتطبيق
// مسؤولة عن:
// 1. عرض Splash Screen عند تشغيل التطبيق.
// 2. التحقق هل المستخدمة جديدة أو سبق لها دخول التطبيق.
// 3. عرض Welcome للمستخدمة الجديدة فقط.
// 4. فتح MyPlants مباشرة للمستخدمة السابقة.

struct ContentView: View {

    // ViewModel المسؤول عن بيانات النباتات.
    @StateObject private var viewModel = PlantViewModel()

    // حفظ حالة إكمال الترحيب بين مرات تشغيل التطبيق.
    @AppStorage("hasCompletedWelcome")
    private var hasCompletedWelcome = false

    // التحكم في ظهور شاشة البداية.
    @State private var showSplash = true

    var body: some View {
        Group {

            if showSplash {

                // MARK: - Splash Screen
                SplashScreen {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showSplash = false
                    }
                }
                .transition(.opacity)

            } else if hasCompletedWelcome {

                // MARK: - مستخدمة سابقة
                // الانتقال مباشرة إلى صفحة النباتات.
                MyPlantsScreen(viewModel: viewModel)
                    .transition(.opacity)

            } else {

                // MARK: - مستخدمة جديدة
                // عرض صفحة الترحيب مرة واحدة فقط.
                WelcomeScreen {

                    // حفظ أن المستخدمة أكملت الترحيب.
                    hasCompletedWelcome = true

                    // طلب صلاحية الإشعارات.
                    viewModel.requestNotifications()
                }
                .transition(.opacity)
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - معاينة التطبيق
#Preview {
    ContentView()
}
