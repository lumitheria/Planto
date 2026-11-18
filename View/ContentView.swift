
import SwiftUI

// MARK: - التنقل الرئيسي حسب User Flow
// Splash -> New User? -> Welcome أو My Plants
// لا ننشئ Home Page إضافية.
// MyPlantsScreen هي الصفحة الرئيسية الموجودة أصلًا.

struct ContentView: View {

    // مدير بيانات النباتات.
    @StateObject private var viewModel = PlantViewModel()

    // حفظ حالة تجاوز صفحة الترحيب.
    @AppStorage("hasCompletedWelcome")
    private var hasCompletedWelcome = false

    // إظهار Splash عند تشغيل التطبيق.
    @State private var showSplash = true

    var body: some View {
        Group {

            if showSplash {

                // شاشة البداية.
                SplashScreen {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showSplash = false
                    }
                }
                .transition(.opacity)

            } else if hasCompletedWelcome {

                // مستخدمة سابقة:
                // تنتقل مباشرة إلى صفحة النباتات.
                MyPlantsScreen(viewModel: viewModel)
                    .transition(.opacity)

            } else {

                // مستخدمة جديدة:
                // تظهر لها صفحة الترحيب الموجودة أصلًا.
                WelcomeScreen {

                    // حفظ إكمال الترحيب.
                    withAnimation(.easeInOut(duration: 0.3)) {
                        hasCompletedWelcome = true
                    }

                    // طلب إذن الإشعارات.
                    viewModel.requestNotifications()
                }
                .transition(.opacity)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
