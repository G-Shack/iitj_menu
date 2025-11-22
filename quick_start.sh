#!/bin/bash

# IITJ Menu App - Quick Start Script
# This script helps you get started with the app

echo "🎉 IITJ Menu App - Quick Start"
echo "================================"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter from https://flutter.dev"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n 1)"
echo ""

# Check Flutter doctor
echo "🔍 Running Flutter Doctor..."
flutter doctor
echo ""

# Get dependencies
echo "📦 Installing dependencies..."
flutter pub get
echo ""

# Check for Firebase configuration
if [ ! -f "android/app/google-services.json" ]; then
    echo "⚠️  WARNING: android/app/google-services.json not found"
    echo "   You need to add Firebase configuration for Android"
    echo "   See SETUP_GUIDE.md for instructions"
    echo ""
fi

if [ ! -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo "⚠️  WARNING: ios/Runner/GoogleService-Info.plist not found"
    echo "   You need to add Firebase configuration for iOS"
    echo "   See SETUP_GUIDE.md for instructions"
    echo ""
fi

# Analyze code
echo "🔍 Analyzing code..."
flutter analyze
echo ""

# Run tests
echo "🧪 Running tests..."
flutter test
echo ""

echo "================================"
echo "✅ Setup Complete!"
echo ""
echo "📋 Next Steps:"
echo "1. Setup Firebase (see SETUP_GUIDE.md)"
echo "2. Add google-services.json for Android"
echo "3. Add GoogleService-Info.plist for iOS"
echo "4. Run: flutter run"
echo ""
echo "📚 Documentation:"
echo "- SETUP_GUIDE.md - Complete setup instructions"
echo "- BUILD_SUMMARY.md - What's been built"
echo "- firebase_remote_config_template.json - Menu template"
echo ""
echo "🚀 Ready to launch!"
