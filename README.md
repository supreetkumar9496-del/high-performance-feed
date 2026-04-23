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
