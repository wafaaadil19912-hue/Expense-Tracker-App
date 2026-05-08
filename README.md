# Personal Expense Tracker

A lightweight, efficient, and offline-first mobile application built with **Flutter** to help users track their income and expenses, manage categories, and visualize spending habits through interactive charts.

## 📱 Key Features
*   **Transaction Management:** Seamlessly add, edit, or delete income and expense entries.
*   **Custom Categories:** Organize finances with predefined categories or create your own with custom colors and icons.
*   **Financial Insights:** 
    *   Real-time monthly balance summaries.
    *   Visual expense distribution via **Pie Charts** .
    *   Visual income source tracking via **Pie Charts** .
*   **Offline Access:** All data is stored locally on your device; no internet connection is required.

## 🛠️ Tech Stack & Dependencies
*   **Framework:** [Flutter](https://flutter.dev/)
*   **State Management:** [GetX](https://pub.dev/packages/get) (for reactive state and dependency injection).
*   **Local Storage:** [Hive](https://pub.dev/packages/hive) (a lightweight, NoSQL key-value database).
*   **Charts:** [fl_chart](https://pub.dev/packages/fl_chart) (for data visualization).
*   **Utilities:**     *   `intl` for date and currency formatting.
    *   `uuid` for generating unique transaction IDs.

## 🏗️ Architecture
The app follows a **Service-Controller-View** pattern to ensure clean separation of concerns:
1.  **Models (`/models`):** Define the data structure of `Transaction` and `Category`.
2.  **Services (`/services`):** Handle low-level logic for Hive database operations.
3.  **Controllers (`/controllers`):** Manage state, business logic (calculations, filters, CRUD), and serve data to the UI.
4.  **Views (`/screens`):** The presentation layer built with Flutter widgets.
5.  **Widgets (`/widgets`):** Reusable UI components like `CustomPieChart` and `CategoryChip`.

## 💾 Local Storage Strategy
We use **Hive** because it is significantly faster than SQLite for simple CRUD operations.
*   **Type Adapters:** Used to map complex Dart objects (Transaction, Category) into binary format for efficient storage.
*   **Code Generation:** We use `build_runner` to automatically generate `*.g.dart` adapter files, keeping the data layer robust and type-safe.

## 🚀 Getting Started
1.  **Install Dependencies:**     ```bash
    flutter pub get
    ```
2.  **Generate Adapters (If needed):**     ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
3.  **Run the App:**     ```bash
    flutter run
    ```