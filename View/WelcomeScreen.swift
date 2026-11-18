
import SwiftUI

// MARK: - صفحة الترحيب
// تعرض صورة Plant الأولى، النصوص، وزر بدء التطبيق.
// لا تحتوي على عمليات تعديل بيانات النباتات.

struct WelcomeScreen: View {

    // الدالة التي ينفذها الزر للانتقال إلى صفحة النباتات.
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: 0) {

            // العنوان المشترك.
            PlantsHeader()

            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {

                        Spacer(minLength: 40)

                        // صورة النبتة الأولى من Assets.
                        PlantIllustration(imageName: "Plant")

                        // عنوان الترحيب.
                        Text("Start your plant journey!")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.top, 24)

                        // وصف التطبيق.
                        Text(
                            "Now all your plants will be in one place and\nwe will help you take care of them :) 🪴"
                        )
                        .font(.system(size: 15))
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 24)

                        Spacer(minLength: 42)

                        // زر الانتقال إلى صفحة النباتات.
                        Button(action: onStart) {

                            Text("Set Plant Reminder")
                                .font(
                                    .system(
                                        size: 16,
                                        weight: .medium
                                    )
                                )
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 43)
                                .background(
                                    PlantTheme.buttonGradient
                                )
                                .clipShape(Capsule())
                                .overlay {
                                    Capsule()
                                        .stroke(
                                            Color.white.opacity(0.25),
                                            lineWidth: 1
                                        )
                                }
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 74)

                        Spacer(minLength: 40)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: geometry.size.height)
                }
                .scrollIndicators(.hidden)
            }
        }
        .background(Color.black.ignoresSafeArea())
    }
}
