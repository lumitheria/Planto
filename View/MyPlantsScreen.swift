
import SwiftUI

// MARK: - صفحة النباتات
// هذا الملف مسؤول عن عرض البيانات والتفاعل مع المستخدمة.
// جميع عمليات البيانات تتم من خلال PlantViewModel.

struct MyPlantsScreen: View {

    // ViewModel مشترك مع ContentView.
    @ObservedObject var viewModel: PlantViewModel

    // التحكم في فتح صفحة إضافة نبتة.
    @State private var showAdd = false

    // النبتة المختارة للتعديل.
    @State private var editingPlant: PlantItem?

    var body: some View {
        VStack(spacing: 0) {

            // العنوان المشترك.
            PlantsHeader()

            if viewModel.plants.isEmpty {

                // حالة عدم وجود نباتات.
                emptyState

            } else if viewModel.allDone {

                // حالة اكتمال ري جميع النباتات.
                allDoneState
                    .transition(.opacity)

            } else {

                // عرض النباتات وشريط التقدم.
                plantsContent
                    .transition(.opacity)
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(Color.black.ignoresSafeArea())

        // MARK: - زر إضافة نبتة
        .overlay(alignment: .bottomTrailing) {
            Button {
                showAdd = true
            } label: {
                Image(systemName: "plus")
                    .font(
                        .system(
                            size: 23,
                            weight: .light
                        )
                    )
                    .foregroundStyle(.white)
                    .frame(width: 46, height: 46)
                    .background(PlantTheme.buttonGradient)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(
                                Color.white.opacity(0.25),
                                lineWidth: 1
                            )
                    }
            }
            .buttonStyle(.plain)
            .padding(.trailing, 28)
            .padding(.bottom, 26)
        }

        // MARK: - فتح صفحة إضافة نبتة
        .sheet(isPresented: $showAdd) {
            SetReminderView { plant in

                // إرسال النبتة الجديدة إلى ViewModel لحفظها.
                withAnimation(PlantTheme.animation) {
                    viewModel.add(plant)
                }
            }
            .presentationDragIndicator(.hidden)
        }

        // MARK: - فتح صفحة تعديل نبتة
        // يمكن تعديل أي نبتة بغض النظر عن حالة الري.
        .sheet(item: $editingPlant) { plant in
            SetReminderView(
                existing: plant,

                onSave: { updated in

                    // إرسال البيانات المعدلة إلى ViewModel.
                    withAnimation(PlantTheme.animation) {
                        viewModel.update(updated)
                    }
                },

                onDelete: {

                    // حذف النبتة باستخدام ViewModel.
                    withAnimation(PlantTheme.animation) {
                        viewModel.delete(plant)
                    }
                }
            )
            .presentationDragIndicator(.hidden)
        }

        // تحديث حالات الري عند ظهور الشاشة.
        .onAppear {
            viewModel.refresh()
        }

        // الحركة عند الانتقال إلى صفحة All Done.
        .animation(
            PlantTheme.animation,
            value: viewModel.allDone
        )
    }

    // MARK: - حالة عدم وجود نباتات
    private var emptyState: some View {
        VStack {

            Spacer()

            Text("No reminders set yet..")
                .font(.system(size: 15))
                .foregroundStyle(.gray)

            Spacer()
        }
    }

    // MARK: - شريط تقدم الري
    private var progressHeader: some View {
        VStack(spacing: 17) {

            // تغيير النص حسب عدد النباتات التي تم ريها.
            Text(
                viewModel.completedCount == 0
                ? "Your plants are waiting for a sip 💦"
                : "\(viewModel.completedCount) of your plants feel loved today✨"
            )
            .font(
                .system(
                    size: 14,
                    weight: .medium
                )
            )
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.8)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {

                    // خلفية شريط التقدم.
                    Capsule()
                        .fill(Color.gray.opacity(0.35))

                    // الجزء الأخضر يمثل نسبة الإنجاز.
                    Capsule()
                        .fill(PlantTheme.green)
                        .frame(
                            width: geometry.size.width *
                                CGFloat(viewModel.progress)
                        )
                }
            }
            .frame(height: 8)
        }
        .padding(.horizontal, 26)
        .padding(.top, 39)

        // حركة تعبئة شريط التقدم.
        .animation(
            .easeInOut(duration: 0.35),
            value: viewModel.progress
        )
    }

    // MARK: - قائمة النباتات
    private var plantsContent: some View {
        VStack(spacing: 0) {

            progressHeader

            List {

                // ViewModel يعيد النباتات المسقية أولًا.
                ForEach(viewModel.sortedPlants) { plant in
                    plantRow(plant)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .padding(.top, 31)

            // تحريك الصفوف عند تغيير ترتيب النباتات.
            .animation(
                PlantTheme.animation,
                value: viewModel.sortedPlants.map(\.id)
            )
        }
    }

    // MARK: - صف النبتة
    private func plantRow(_ plant: PlantItem) -> some View {
        HStack(alignment: .center, spacing: 15) {

            // MARK: - زر تحديد اكتمال الري
            Button {

                // إرسال طلب تغيير حالة الري إلى ViewModel.
                withAnimation(PlantTheme.animation) {
                    viewModel.toggle(plant)
                }

            } label: {
                ZStack {

                    // الدائرة الخارجية.
                    Circle()
                        .stroke(
                            plant.isWatered
                            ? PlantTheme.green
                            : Color.gray.opacity(0.85),
                            lineWidth: 1.3
                        )
                        .frame(width: 19, height: 19)

                    if plant.isWatered {

                        // الدائرة الخضراء عند اكتمال الري.
                        Circle()
                            .fill(PlantTheme.green)
                            .frame(width: 19, height: 19)

                        // علامة الصح السوداء داخل الدائرة.
                        Image(systemName: "checkmark")
                            .font(
                                .system(
                                    size: 10,
                                    weight: .semibold
                                )
                            )
                            .foregroundStyle(.black)
                    }
                }
            }
            .buttonStyle(.plain)

            // MARK: - تفاصيل النبتة
            // الضغط على المعلومات يفتح صفحة التعديل.
            Button {

                editingPlant = plant

            } label: {
                VStack(
                    alignment: .leading,
                    spacing: 5
                ) {

                    // الغرفة التي توجد فيها النبتة.
                    HStack(spacing: 5) {

                        Image(systemName: "location")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)

                        Text("in \(plant.room)")
                            .font(.system(size: 11))
                            .foregroundStyle(.gray)
                    }

                    // اسم النبتة.
                    Text(plant.name)
                        .font(
                            .system(
                                size: 20,
                                weight: .regular
                            )
                        )
                        .foregroundStyle(
                            plant.isWatered
                            ? Color.gray
                            : Color.white
                        )
                        .lineLimit(1)

                    // MARK: - معلومات الإضاءة والماء
                    HStack(spacing: 7) {

                        // معلومات الإضاءة.
                        HStack(spacing: 4) {

                            Image(systemName: "sun.max")
                                .foregroundStyle(
                                    PlantTheme.yellow
                                )

                            Text(plant.light)
                                .foregroundStyle(
                                    PlantTheme.yellow
                                )
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(PlantTheme.tag)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )

                        // كمية الماء.
                        HStack(spacing: 4) {

                            Image(systemName: "drop")

                            Text(plant.water)
                        }
                        .foregroundStyle(PlantTheme.blue)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(PlantTheme.tag)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )
                    }
                    .font(.system(size: 10))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .opacity(plant.isWatered ? 0.55 : 1)
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }

        // ارتفاع صف النبتة كما في النسخة السابقة.
        .frame(height: 94)

        .listRowBackground(Color.black)
        .listRowSeparatorTint(PlantTheme.separator)

        .listRowInsets(
            EdgeInsets(
                top: 0,
                leading: 16,
                bottom: 0,
                trailing: 16
            )
        )

        // MARK: - حذف النبتة بالسحب
        .swipeActions(
            edge: .trailing,
            allowsFullSwipe: false
        ) {
            Button(role: .destructive) {

                withAnimation(PlantTheme.animation) {
                    viewModel.delete(plant)
                }

            } label: {
                Image(systemName: "trash")
            }
            .tint(.red)
        }
    }

    // MARK: - صفحة اكتمال ري جميع النباتات
    private var allDoneState: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {

                Spacer(minLength: 40)

                // صورة النبتة الثانية من Assets.
                PlantIllustration(imageName: "Plant2")

                // عنوان اكتمال الري.
                Text("All Done!🎉")
                    .font(
                        .system(
                            size: 24,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)
                    .padding(.top, 23)

                // النص الموجود أسفل العنوان.
                Text("All Reminders Completed")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
                    .padding(.top, 13)

                Spacer(minLength: 40)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: geometry.size.height)
        }
    }
}
