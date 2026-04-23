# 🚀 High Performance Feed App

## 📌 Overview
This is a high-performance Instagram-like feed app built using Flutter and Supabase.
It focuses on smooth scrolling, optimized image loading, and efficient memory usage.

---

## ✨ Features
- Infinite scrolling feed
- Pull-to-refresh
- Optimistic like/unlike UI
- Detail screen with Hero animation
- High-resolution image viewing
- Image caching using CachedNetworkImage
- Backend integration with Supabase
- Python-based image processing pipeline

---

## Riverpod State Management Approach
I used Riverpod to separate UI logic from data-fetching logic.

- `feed_service_provider.dart` provides access to the feed service.
- The feed screen reads the provider to fetch posts from Supabase.
- Pagination state such as current page, loaded posts, and loading flags is handled in the screen state.
- For likes, I implemented optimistic UI updates locally so the heart icon and count update instantly, while the Supabase RPC runs asynchronously in the background.

## How I Verified RepaintBoundary
I wrapped complex post cards with `RepaintBoundary` because the cards include a heavy `BoxShadow`.  
To verify it, I checked the app during scrolling and confirmed smooth rendering behavior. The goal was to reduce unnecessary repaint work for each card during fast scrolls.

## How I Verified memCacheWidth
I used `memCacheWidth` in `CachedNetworkImage` so the decoded image size better matches the size actually shown in the UI.  
This helps reduce RAM usage because full-resolution images are not decoded unnecessarily for the feed thumbnails.

## ⚡ Performance Optimizations

### 🧠 RepaintBoundary
Used to isolate widgets and prevent unnecessary rebuilds.

### 📏 memCacheWidth
Reduces memory usage by loading optimized image sizes.

### 🖼️ Tiered Image Loading
- Thumbnail → Feed
- Mobile → Detail screen
- Raw → High-res view

---

## 🐍 Python Pipeline
- Converts images into multiple sizes
- Uploads to Supabase Storage
- Inserts URLs into database

---

## 🛠️ Tech Stack
- Flutter (UI)
- Supabase (Backend)
- Python (Image processing)
- CachedNetworkImage


---

## ▶️ How to Run

```bash
flutter pub get
flutter run
