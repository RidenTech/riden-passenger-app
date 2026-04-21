# Android Manifest & API Configuration - Setup Guide

## Overview

The app uses **two different Google APIs** for different purposes:

1. **Google Maps API** - For displaying maps in the app (configured in Android Manifest)
2. **Google Places API** - For location search suggestions (configured in constants.dart)

## API Key Configuration

### Current Setup

#### 1. Android Manifest (Google Maps API)
**File:** `android/app/src/main/AndroidManifest.xml`

```xml
<meta-data 
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyD3Tw1rkB9PWTx_7vRUrGvgQfxIrBbNYkg"/>
```

✅ **Status:** Already configured for Google Maps
- This key enables map display functionality
- Used by `google_maps_flutter` plugin

#### 2. Constants File (Google Places API)
**File:** `lib/config/constants.dart`

```dart
static const String googlePlacesApiKey = 'YOUR_API_KEY_HERE';
```

⚠️ **Status:** Needs configuration
- Replace `YOUR_API_KEY_HERE` with your actual Google Places API key
- This key enables location search suggestions

### How They're Used

| API | Purpose | Location | Status |
|-----|---------|----------|--------|
| Google Maps | Display maps on screens | AndroidManifest.xml | ✓ Configured |
| Google Places Autocomplete | Real-time location search | constants.dart | ⚠️ Needs key |
| Google Places Details | Get place coordinates & address | constants.dart | ⚠️ Needs key |

## Getting Your Google Places API Key

1. **Visit Google Cloud Console**
   - Go to: https://console.cloud.google.com/

2. **Create/Select Project**
   - If new: Click "New Project" → Enter "Riden App" → Create
   - If existing: Select from dropdown

3. **Enable APIs**
   - Search: "Places API"
   - Click Result → "Enable"
   - Search: "Maps JavaScript API" 
   - Click Result → "Enable"

4. **Create API Key**
   - Left sidebar: "Credentials"
   - Click: "Create Credentials" → "API Key"
   - Copy the key

5. **Add to Project**
   - Open `lib/config/constants.dart`
   - Replace `YOUR_API_KEY_HERE` with your key:
   ```dart
   static const String googlePlacesApiKey = 'AIzaSyD...YOUR_KEY...';
   ```

## Support Module Integration

### Navigation Flow

The Support module is now fully integrated into the bottom navigation across all screens:

```
Home Screen
    ↓
[Support] Button → Support Page
    ↓
Account → "Contact Support" → Support Page
    ↓
About Us → Bottom Nav [Support] → Support Page
```

### Files Modified

1. **[lib/home/home_screen.dart](../../lib/home/home_screen.dart)**
   - Added Support import
   - Updated bottom nav to navigate to Support when index 1 is selected

2. **[lib/support/support.dart](../../lib/support/support.dart)**
   - Added AccountScreen import
   - Updated bottom nav navigation logic
   - Now properly routes to Account (index 3) and home (other indices)

3. **[lib/account/account_screen.dart](../../lib/account/account_screen.dart)**
   - Added Support import
   - Added `onTap` to "Contact Support" menu item → navigates to Support
   - Updated bottom nav to route Support (index 1) and Account (index 3)

4. **[lib/account/Aboutus/about_us.dart](../../lib/account/Aboutus/about_us.dart)**
   - Added Support import
   - Updated bottom nav navigation with full routing logic

## Support Features

The Support page provides:

- **Call Helpline** - Direct phone support
- **Instant Support** - Chat-based support
- **Submit Complaint Ticket** - Create support tickets
- **Support Files** - Access support documentation

## Testing Navigation

Test the following flows:

1. ✓ **Home → Support Tab** - Should navigate to Support page
2. ✓ **Account → Contact Support** - Should navigate to Support page
3. ✓ **Support → Account Tab** - Should navigate to Account page
4. ✓ **Support → Other Tabs** - Should return to previous page
5. ✓ **About Us → Support Tab** - Should navigate to Support page

## API Key Security Best Practices

### For Development
- Use your personal API key
- Enable it for all environments temporarily

### For Production
1. **Create separate keys** for each environment
2. **Restrict API keys** in Google Cloud Console:
   - Under "API restrictions": Select only "Places API"
   - Under "Application restrictions":
     - For Android: Add your signing certificate fingerprints
     - For iOS: Add your bundle IDs
3. **Monitor usage** in Google Cloud Console
4. **Set billing alerts** to prevent unexpected charges

## Troubleshooting

### Maps Not Loading
- ✓ Check Android Manifest for Map API key
- Verify key is valid in Google Cloud Console
- Ensure "Maps JavaScript API" is enabled

### Location Search Not Working
- ✓ Check constants.dart for Places API key
- Verify key is not placeholder text
- Ensure "Places API" is enabled
- Grant location permissions to app

### Navigation Issues
- ✓ Verify imports are added to all screen files
- Check bottom nav onItemSelected logic
- Clear build cache: `flutter clean`

## Files Modified Summary

### New/Updated Files
```
lib/config/constants.dart              ← Add your Places API key here
lib/home/home_screen.dart              ← Support navigation added
lib/support/support.dart               ← Bottom nav routing fixed
lib/account/account_screen.dart        ← Support link added
lib/account/Aboutus/about_us.dart      ← Support routing added
android/app/src/main/AndroidManifest.xml ← Already configured ✓
```

## Next Steps

- [ ] Get your Google Places API key
- [ ] Add key to `lib/config/constants.dart`
- [ ] Test location search
- [ ] Test Support page navigation
- [ ] Verify all bottom nav links work
- [ ] Test on physical device
- [ ] Monitor API usage in Google Cloud Console
