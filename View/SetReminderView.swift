
import SwiftUI

// MARK: - صفحة إضافة وتعديل تذكير النبتة
// هذه الصفحة مسؤولة عن عرض الحقول واستقبال إدخال المستخدمة.
// عند الحفظ، يتم إرسال بيانات النبتة إلى ViewModel عبر onSave.
// لا يتم حفظ البيانات مباشرة من داخل هذه الصفحة.

struct SetReminderView: View {

    // يستخدم لإغلاق الصفحة بعد الحفظ أو عند الضغط على X.
    @Environment(\.dismiss) private var dismiss

    // النبتة الحالية عند التعديل.
    // إذا كانت nil فهذا يعني أننا نضيف نبتة جديدة.
    let existing: PlantItem?

    // دالة إرسال النبتة للحفظ.
    let onSave: (PlantItem) -> Void

    // دالة حذف النبتة، وتستخدم فقط في وضع التعديل.
    let onDelete: (() -> Void)?

    // MARK: - بيانات حقول الإدخال
    // نستخدم State حتى تتحدث القيم مباشرة عند تغييرها.
    @State private var name: String
    @State private var room: String
    @State private var light: String
    @State private var days: String
    @State private var water: String

    // التحكم في إظهار رسالة تأكيد الحذف.
    @State private var showDeleteAlert = false

    // MARK: - ألوان الصفحة

    // لون خلفية صفحة التذكير.
    private let background = Color(
        red: 0.115,
        green: 0.115,
        blue: 0.12
    )

    // لون خلفية حقول الإدخال.
    private let field = Color(
        red: 0.175,
        green: 0.175,
        blue: 0.185
    )

    // MARK: - خيارات القوائم

    // الغرف المتاحة.
    private let rooms = [
        "Bedroom",
        "Living Room",
        "Kitchen",
        "Balcony",
        "Bathroom"
    ]

    // خيارات الإضاءة.
    private let lights = [
        "Full Sun",
        "Partial Sun",
        "Low Light"
    ]

    // خيارات فترة الري.
    private let wateringOptions = [
        "Every day",
        "Every 2 days",
        "Every 3 days",
        "Once a week",
        "Every 10 days",
        "Every 2 weeks"
    ]

    // خيارات كمية الماء.
    private let waterOptions = [
        "20-50 ml",
        "50-100 ml",
        "100-200 ml",
        "200-300 ml"
    ]

    // MARK: - تهيئة الصفحة
    // عند إضافة نبتة جديدة، نستخدم القيم الافتراضية.
    // عند تعديل نبتة، نعرض بياناتها المحفوظة.

    init(
        existing: PlantItem? = nil,
        onSave: @escaping (PlantItem) -> Void,
        onDelete: (() -> Void)? = nil
    ) {
        self.existing = existing
        self.onSave = onSave
        self.onDelete = onDelete

        _name = State(
            initialValue: existing?.name ?? ""
        )

        _room = State(
            initialValue: existing?.room ?? "Bedroom"
        )

        _light = State(
            initialValue: existing?.light ?? "Full Sun"
        )

        _days = State(
            initialValue: existing?.wateringDays ?? "Every day"
        )

        _water = State(
            initialValue: existing?.water ?? "20-50 ml"
        )
    }

    // MARK: - تصميم الصفحة
    var body: some View {
        VStack(spacing: 0) {

            // شريط العنوان وأزرار الإغلاق والحفظ.
            navigationBar

            // يسمح بالتمرير على الشاشات الصغيرة.
            ScrollView {
                VStack(spacing: 0) {

                    // MARK: - حقل اسم النبتة
                    HStack(spacing: 12) {

                        Text("Plant Name")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .fixedSize()

                        TextField("Pothos", text: $name)
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .tint(PlantTheme.green)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.words)
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 58)
                    .background(field)
                    .clipShape(Capsule())
                    .padding(.top, 48)

                    // MARK: - مجموعة الغرفة والإضاءة
                    VStack(spacing: 0) {

                        inputRow(
                            title: "Room",
                            icon: "location",
                            selection: $room,
                            options: rooms
                        )

                        separator

                        inputRow(
                            title: "Light",
                            icon: "sun.max",
                            selection: $light,
                            options: lights
                        )
                    }
                    .background(field)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 28)
                    )
                    .padding(.top, 49)

                    // MARK: - مجموعة فترة الري وكمية الماء
                    VStack(spacing: 0) {

                        inputRow(
                            title: "Watering Days",
                            icon: "drop",
                            selection: $days,
                            options: wateringOptions
                        )

                        separator

                        inputRow(
                            title: "Water",
                            icon: "drop",
                            selection: $water,
                            options: waterOptions
                        )
                    }
                    .background(field)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 28)
                    )
                    .padding(.top, 41)

                    // MARK: - زر حذف التذكير
                    // يظهر فقط عند تعديل نبتة محفوظة.
                    if existing != nil {
                        Button {
                            showDeleteAlert = true
                        } label: {
                            Text("Delete Reminder")
                                .font(.system(size: 16))
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity)
                                .frame(height: 51)
                                .background(field)
                                .clipShape(Capsule())
                        }
                        .padding(.horizontal, 8)
                        .padding(.top, 74)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background(background.ignoresSafeArea())
        .preferredColorScheme(.dark)

        // MARK: - رسالة تأكيد الحذف
        // لا يتم حذف النبتة إلا بعد تأكيد العملية.
        .alert(
            "Delete Reminder?",
            isPresented: $showDeleteAlert
        ) {

            Button("Delete", role: .destructive) {
                onDelete?()
                dismiss()
            }

            Button("Cancel", role: .cancel) {}

        } message: {
            Text("This reminder will be deleted.")
        }
    }

    // MARK: - شريط التنقل العلوي
    private var navigationBar: some View {
        HStack {

            // MARK: - زر الإغلاق
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.18),
                                Color.white.opacity(0.04)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(
                                Color.white.opacity(0.25),
                                lineWidth: 1
                            )
                    }
            }

            Spacer()

            // عنوان الصفحة.
            Text("Set Reminder")
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.white)

            Spacer()

            // MARK: - زر حفظ النبتة
            Button {
                savePlant()
            } label: {
                Image(systemName: "checkmark")
                    .font(
                        .system(
                            size: 20,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        PlantTheme.buttonGradient
                    )
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(
                                Color.white.opacity(0.25),
                                lineWidth: 1
                            )
                    }
            }

            // منع الحفظ عندما يكون اسم النبتة فارغًا.
            .disabled(
                name.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty
            )

            // تخفيف ظهور الزر إذا لم يتم إدخال اسم.
            .opacity(
                name.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty ? 0.75 : 1
            )
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
    }

    // MARK: - الخط الفاصل بين الحقول
    private var separator: some View {
        Rectangle()
            .fill(Color.white.opacity(0.13))
            .frame(height: 0.5)
            .padding(.horizontal, 16)
    }

    // MARK: - صف اختيار مشترك
    // نستخدم هذه الدالة لعرض خيارات:
    // Room و Light و Watering Days و Water.
    // كل صف يحتوي على أيقونة وعنوان وقائمة خيارات.

    private func inputRow(
        title: String,
        icon: String,
        selection: Binding<String>,
        options: [String]
    ) -> some View {

        HStack(spacing: 8) {

            // الأيقونة من مكتبة SF Symbols.
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(.white)
                .frame(width: 20)

            // عنوان الحقل.
            Text(title)
                .font(.system(size: 16))
                .foregroundStyle(.white)

            Spacer(minLength: 8)

            // MARK: - قائمة الخيارات
            // Menu تفتح القائمة عند الضغط.
            // Picker يربط الاختيار بالقيمة المخزنة في State.
            Menu {
                Picker(title, selection: selection) {

                    // عرض جميع الخيارات الموجودة في المصفوفة.
                    // لكل خيار قيمة tag خاصة به.
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
            } label: {

                HStack(spacing: 5) {

                    // عرض القيمة المختارة حاليًا.
                    Text(selection.wrappedValue)
                        .foregroundStyle(.gray)
                        .lineLimit(1)

                    // أيقونة تشير إلى إمكانية تغيير الاختيار.
                    Image(
                        systemName: "chevron.up.chevron.down"
                    )
                    .font(.system(size: 11))
                    .foregroundStyle(.gray)
                }
                .font(.system(size: 15))
            }
        }
        .padding(.horizontal, 18)
        .frame(height: 47)
    }

    // MARK: - حفظ بيانات النبتة
    // نحافظ على معرف النبتة عند التعديل.
    // وننشئ نبتة جديدة عند الإضافة.
    // يتم إرسال النتيجة عبر onSave إلى ViewModel.

    private func savePlant() {

        // إزالة المسافات الزائدة من بداية ونهاية الاسم.
        let trimmed = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        // منع حفظ نبتة بدون اسم.
        guard !trimmed.isEmpty else {
            return
        }

        // استخدام النبتة الموجودة عند التعديل.
        // أو إنشاء نبتة جديدة عند الإضافة.
        var plant = existing ?? PlantItem(
            name: trimmed,
            room: room,
            light: light,
            wateringDays: days,
            water: water
        )

        // معرفة هل تغيرت فترة الري.
        let changedDays = plant.wateringDays != days

        // تحديث بيانات النبتة.
        plant.name = trimmed
        plant.room = room
        plant.light = light
        plant.wateringDays = days
        plant.water = water

        // إعادة حالة الري عند إنشاء نبتة جديدة
        // أو تغيير الفترة المحددة للري.
        if existing == nil || changedDays {
            plant.isWatered = false
            plant.nextDue = Date()
        }

        // إرسال البيانات للحفظ.
        onSave(plant)

        // إغلاق الصفحة بعد الحفظ.
        dismiss()
    }
}
