
import SwiftUI

// MARK: - الواجهة الرئيسية للتطبيق
// هذا الملف يربط الواجهات بالـ ViewModel.
// لا يحتوي على منطق إضافة أو حذف النباتات.

struct ContentView: View {

    // إنشاء ViewModel واحد لمشاركة البيانات بين الشاشات.
    @StateObject private var viewModel = PlantViewModel()

    // عرض صفحة الترحيب عند بداية تشغيل التطبيق.
    @State private var started = false

    var body: some View {
        Group {

            if started {

                // عرض صفحة النباتات بعد بدء استخدام التطبيق.
                MyPlantsScreen(viewModel: viewModel)
                    .transition(.opacity)

            } else {

                // عرض صفحة الترحيب.
                WelcomeScreen {

                    // الانتقال إلى صفحة النباتات بحركة ناعمة.
                    withAnimation(.easeInOut(duration: 0.3)) {
                        started = true
                    }

                    // طلب السماح بإشعارات الري.
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
