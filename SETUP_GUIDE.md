# IITJ Menu App - Setup Guide

## 🎉 Congratulations!

The IITJ Menu app has been successfully created with all core functionality implemented!

## ✅ What's Been Completed

### Core Structure
- ✅ Complete project folder structure
- ✅ All dependencies added to pubspec.yaml
- ✅ Design system (colors, typography, dimensions)
- ✅ Light and dark theme support

### Data Layer
- ✅ Meal, MenuItem, and DayMenu models
- ✅ Firebase Remote Config service
- ✅ Local caching with Hive
- ✅ State management with Provider

### UI Screens
- ✅ Splash screen with animations
- ✅ Home screen with:
  - Gradient header
  - Week day selector
  - Current meal indicator with countdown
  - Meal cards (past/active/upcoming states)
  - Pull-to-refresh
- ✅ Meal detail bottom sheet with sharing

### Features
- ✅ Real-time meal status detection
- ✅ Smooth animations and transitions
- ✅ Theme toggle (light/dark)
- ✅ Offline-first architecture
- ✅ Share meal functionality

## 🔥 Firebase Setup Required

To make the app fully functional, you need to set up Firebase:

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Name it "IITJ Menu" or similar
4. Follow the setup wizard

### Step 2: Add Android App

1. In Firebase Console, click "Add app" → Android
2. Package name: `com.iitjodhpur.iitjmenu`
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

### Step 3: Add iOS App (if deploying to iOS)

1. In Firebase Console, click "Add app" → iOS
2. Bundle ID: `com.iitjodhpur.iitjmenu`
3. Download `GoogleService-Info.plist`
4. Place it in: `ios/Runner/GoogleService-Info.plist`

### Step 4: Use FlutterFire CLI (Recommended)

Run this command to automatically configure Firebase:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure --project=your-project-id
```

This will generate the `firebase_options.dart` file automatically.

### Step 5: Setup Remote Config

1. Go to Firebase Console → Remote Config
2. Add parameter: `weekly_menu` (type: JSON)
3. Set default value with this structure:

```json
{
  "monday": {
    "breakfast": {
      "name": "Breakfast",
      "icon": "sunrise",
      "start_time": "07:00",
      "end_time": "09:30",
      "items": [
        {"name": "Poha with Namkeen", "type": "veg", "allergens": []},
        {"name": "Bread & Butter", "type": "veg", "allergens": ["gluten", "dairy"]},
        {"name": "Banana", "type": "vegan", "allergens": []},
        {"name": "Tea/Coffee/Milk", "type": "veg", "allergens": ["dairy"]}
      ],
      "special_note": ""
    },
    "lunch": {
      "name": "Lunch",
      "icon": "restaurant",
      "start_time": "11:30",
      "end_time": "14:00",
      "items": [
        {"name": "Dal Tadka", "type": "veg", "allergens": []},
        {"name": "Paneer Butter Masala", "type": "veg", "allergens": ["dairy"]},
        {"name": "Jeera Rice", "type": "vegan", "allergens": []},
        {"name": "Roti (4 pcs)", "type": "vegan", "allergens": ["gluten"]},
        {"name": "Salad & Pickle", "type": "vegan", "allergens": []},
        {"name": "Gulab Jamun", "type": "veg", "allergens": ["dairy", "gluten"]}
      ],
      "special_note": "Chef's Special Today!"
    },
    "snacks": {
      "name": "Snacks",
      "icon": "local_cafe",
      "start_time": "16:30",
      "end_time": "18:00",
      "items": [
        {"name": "Samosa (2 pcs)", "type": "veg", "allergens": ["gluten"]},
        {"name": "Green Chutney", "type": "vegan", "allergens": []},
        {"name": "Tea/Coffee", "type": "veg", "allergens": ["dairy"]}
      ],
      "special_note": ""
    },
    "dinner": {
      "name": "Dinner",
      "icon": "dinner_dining",
      "start_time": "19:30",
      "end_time": "22:00",
      "items": [
        {"name": "Mixed Dal", "type": "veg", "allergens": []},
        {"name": "Aloo Gobi", "type": "vegan", "allergens": []},
        {"name": "Plain Rice", "type": "vegan", "allergens": []},
        {"name": "Roti (4 pcs)", "type": "vegan", "allergens": ["gluten"]},
        {"name": "Curd", "type": "veg", "allergens": ["dairy"]}
      ],
      "special_note": ""
    }
  }
}
```

4. Duplicate Monday's structure for Tuesday through Sunday
5. Add parameter: `menu_version` (type: String) = "1.0.0"
6. Click "Publish changes"

## 🚀 Running the App

### Without Firebase (Testing Layout)

The app will work with default/cached data even without Firebase configuration:

```bash
flutter run
```

### With Firebase

After completing Firebase setup:

```bash
flutter clean
flutter pub get
flutter run
```

## 📱 Building for Release

### Android

```bash
flutter build apk --release
# or for App Bundle
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## 🎨 Customization Guide

### Change Colors

Edit `lib/core/constants/app_colors.dart`

### Change Fonts

Edit `lib/core/constants/app_text_styles.dart`

### Modify Meal Times

Update the `start_time` and `end_time` in Firebase Remote Config

### Add New Dietary Types

1. Add to enum in `lib/data/models/menu_item_model.dart`
2. Add color in `lib/core/constants/app_colors.dart`
3. Update parsing logic in `menu_item_model.dart`

## 🐛 Troubleshooting

### "Firebase not initialized" error

Make sure you've:
1. Added `google-services.json` for Android
2. Added `GoogleService-Info.plist` for iOS
3. Run `flutter clean && flutter pub get`

### Menu not loading

1. Check Firebase Remote Config is published
2. Check internet connection
3. Clear app data and restart

### Animations not smooth

1. Run in release mode: `flutter run --release`
2. Profile mode: `flutter run --profile`

## 📦 Key Dependencies

- **provider**: State management
- **firebase_core**: Firebase initialization
- **firebase_remote_config**: Dynamic menu updates
- **hive**: Local caching
- **google_fonts**: Inter font family
- **share_plus**: Share functionality
- **intl**: Date formatting

## 🔄 Updating Menu

Simply update the JSON in Firebase Remote Config and publish. The app will:
1. Show cached menu immediately
2. Fetch updates in background
3. Refresh when user pulls down

## 📈 Next Steps

### Immediate
1. ✅ Complete Firebase setup
2. ✅ Test on physical devices
3. ✅ Add your actual menu data

### Future Enhancements
- 🔔 Meal time notifications
- ⭐ Favorites system
- 📊 Nutrition information
- 🔍 Search functionality
- 🗓️ Weekly view
- 👤 User preferences
- 📱 Push notifications for special meals

## 👨‍💻 Developer

Made with ❤️ by **Om Tathed** for IITJ Community

## 📄 License

This project is created for IIT Jodhpur community use.

---

**Need Help?** Check the instruction file at `.github/instructions/iitj_menu.instructions.md` for detailed implementation guide.
