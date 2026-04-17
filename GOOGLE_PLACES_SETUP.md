# Google Places API Integration - Setup Guide

## Overview
The home screen now uses **Google Places API** for real-time location search suggestions instead of hardcoded locations. When users type in the search bar, they'll see live suggestions just like Google Maps.

## What Changed
- ✅ Removed 20+ hardcoded location entries
- ✅ Added Google Places Autocomplete Service
- ✅ Added Search debouncing (500ms) to reduce API calls
- ✅ Added Loading indicators during search
- ✅ Integrated location bias (searches near user's current location)
- ✅ Proper error handling and logging

## Setup Instructions

### Step 1: Get Google Places API Key

1. **Go to Google Cloud Console**
   - Visit: https://console.cloud.google.com/

2. **Create a New Project** (if you don't have one)
   - Click on project dropdown → Select "New Project"
   - Enter project name (e.g., "Riden App")
   - Click "Create"

3. **Enable Required APIs**
   - Search for "Places API" in the search bar
   - Click on "Places API"
   - Click "Enable"
   - Also enable "Maps JavaScript API" if not already enabled

4. **Create API Key**
   - Go to Credentials (left sidebar)
   - Click "Create Credentials" → "API Key"
   - Copy the generated API key

5. **Restrict API Key (Recommended for Production)**
   - Click on your API key
   - Under "Application restrictions", select "Android" and "iOS"
   - Add your app's fingerprints/bundle IDs
   - Under "API restrictions", select "Places API"

### Step 2: Add API Key to Your Project

1. **Update Android Configuration**
   - Open `android/app/src/main/AndroidManifest.xml`
   - Add this inside the `<application>` tag:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_GOOGLE_PLACES_API_KEY_HERE" />
   ```

2. **Update iOS Configuration**
   - Open `ios/Runner/AppDelegate.swift`
   - Add at the top:
   ```swift
   import GoogleMaps

   GMSServices.provideAPIKey("YOUR_GOOGLE_PLACES_API_KEY_HERE")
   ```

3. **Add to Flutter Constants**
   - Open `lib/config/constants.dart`
   - Replace `YOUR_GOOGLE_PLACES_API_KEY_HERE` with your actual API key:
   ```dart
   static const String googlePlacesApiKey = 'AIzaSyD...YOUR_KEY_HERE';
   ```

### Step 3: Test the Implementation

1. **Run the App**
   ```bash
   flutter pub get
   flutter run
   ```

2. **Test Search**
   - Navigate to Home Screen
   - Click on the location search bar
   - Type a location name (e.g., "coffee", "restaurant", "hospital")
   - You should see real Google Places suggestions

3. **Expected Behavior**
   - Shows loading indicator while searching
   - Results filtered by proximity to your location
   - Selecting a location adds a blue marker on the map
   - Search is debounced (waits 500ms after typing stops)

## API Call Flow

```
User Types in Search Bar
        ↓
Debounce Timer (500ms)
        ↓
Google Places Autocomplete API
        ↓
Display Suggestions in Dropdown
        ↓
User Selects a Suggestion
        ↓
Fetch Place Details (coordinates, address)
        ↓
Add Marker to Map & Update Search Bar
```

## Cost Optimization

- **Session Tokens**: Uses Google session tokens to group autocomplete + details requests (reduces costs)
- **Debouncing**: Waits 500ms after user stops typing before making API call
- **Location Bias**: Narrows results to 50km radius around user

## Troubleshooting

### "No suggestions appear when typing"
- ✓ Check if API key is correctly added to `constants.dart`
- ✓ Verify Google Places API is enabled in Google Cloud Console
- ✓ Check console logs (search for "❌" symbols)

### "ZERO_RESULTS error"
- This means no places found for that search in your region
- Try searching with more specific terms

### "API Key Invalid" error
- Double-check the API key in `constants.dart`
- Ensure it's properly quoted as a string
- Verify it in Google Cloud Console

### High API Costs
- Verify your API restrictions are set correctly (Android/iOS only)
- Monitor usage in Google Cloud Console
- Session tokens are helping reduce costs by 50%

## Related Files Modified

- `lib/services/location_search_service.dart` - NEW: Google Places API service
- `lib/home/home_screen.dart` - UPDATED: Removed hardcoded data, integrated API
- `lib/config/constants.dart` - UPDATED: Added Google Places configuration

## Key Features

1. **Real-time Suggestions** - Live data from Google Places
2. **Proximity Sorting** - Results sorted by distance to user
3. **Autocomplete** - Smart suggestions as user types
4. **Place Details** - Full address and coordinates on selection
5. **Error Handling** - Graceful fallbacks and user feedback
6. **Performance** - Debouncing and session tokens for efficiency

## Next Steps

- [ ] Add your Google Places API key
- [ ] Configure Android manifest
- [ ] Configure iOS AppDelegate
- [ ] Test on device/emulator
- [ ] Monitor API usage in Google Cloud Console
- [ ] Set up billing alerts if needed

## Support

For issues:
1. Check the console logs (look for 🔵🟢❌ symbols)
2. Verify API key and permissions
3. Check Google Cloud Console for errors
4. Ensure location permissions are granted to app
