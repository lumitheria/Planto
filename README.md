# Planto 🌱

**A little care goes a long way.**

Planto is an iOS plant care reminder app built with SwiftUI. It helps users organize their plants, manage watering routines, and track their daily plant care progress.

## App Preview

| Welcome | My Plants | All Done |
|:---:|:---:|:---:|
| <img src="screenshots/welcome.png" width="200"> | <img src="screenshots/my-plants.png" width="200"> | <img src="screenshots/all-done.png" width="200"> |

## Features

- **Plant Management** — Add, edit, and delete plant reminders.
- **Watering Tracker** — Mark plants as watered and monitor progress.
- **Care Details** — Set room, lighting, water amount, and watering frequency.
- **Notifications** — Receive daily watering reminders.
- **Smart Onboarding** — Splash screen and first-time user detection.
- **Local Storage** — Save plant information across app sessions.
- **Completion Screen** — Celebrate when all reminders are completed.

## Tech Stack

`Swift` · `SwiftUI` · `MVVM` · `UserDefaults` · `UserNotifications`

## Architecture

The app follows the **MVVM (Model–View–ViewModel)** architecture for a clear separation of responsibilities.

```text
Plants/
├── Model/
│   └── PlantItem.swift
├── ViewModel/
│   └── PlantViewModel.swift
├── View/
│   ├── ContentView.swift
│   ├── SplashScreen.swift
│   ├── WelcomeScreen.swift
│   ├── MyPlantsScreen.swift
│   ├── SetReminderView.swift
│   └── PlantComponents.swift
└── PlantsApp.swift
```

## User Flow

**Splash Screen → First-Time User Check → Welcome / My Plants → Add, Edit & Complete Reminders**

New users see the welcome screen, while returning users go directly to their plant dashboard.

## Getting Started

1. Clone the repository.
2. Open the project in Xcode.
3. Select an iOS simulator or connected iPhone.
4. Build and run.

---

Made with SwiftUI 🌱
