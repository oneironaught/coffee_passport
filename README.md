# Coffee Passport ☕

A SwiftUI iOS app to help Starbucks coffee lovers log, review, and explore their favorite whole bean coffees. Featuring personalized stats, achievements, photos, filters, and gallery views.

---

## 📱 Features

- ✅ **Coffee Check-Ins** — Add coffees you've tried with photos, tasting notes, and descriptions.
- ⭐ **Favorites** — Mark coffees you love and view them in a dedicated favorites gallery.
- 🏅 **Achievements** — Earn badges like "Coffee Explorer" or "Master Taster" as you try more coffees.
- 📊 **Stats View** — See how many coffees you've tasted and your progress.
- 🔍 **Filtering & Sorting** — Filter by origin, body, and acidity. Sort by strength and roast level.
- 🖼️ **Gallery View** — Visual grid of checked-in coffees with tap-to-view detail.
- 🧾 **Coffee Detail Pages** — Origin, body, acidity, processing, food pairing, and check-in option.
- 🎨 **Starbucks-Inspired UI** — Clean, minimal layout with Starbucks green theme and icons.

---

## 🛠 Tech Stack

- SwiftUI
- MVVM Architecture
- Codable + UserDefaults for local persistence
- UIKit Integration (camera/photo picker)

---

## 📂 Folder Structure

```
├── Models
│   └── Coffee.swift
├── ViewModels
│   └── CoffeeViewModel.swift
├── Views
│   ├── ContentView.swift
│   ├── CoffeeListView.swift
│   ├── CoffeeDetailView.swift
│   ├── AddCoffeeView.swift
│   ├── CoffeeStatsView.swift
│   ├── CoffeeBadgeView.swift
│   ├── CoffeeGalleryView.swift
│   └── FavoritesView.swift
├── Utilities
│   └── ImagePicker.swift
│   └── VisualEffectBlur.swift
```

---

## 🚀 Getting Started

1. Clone the repo
2. Open in Xcode (iOS 17+ recommended)
3. Run the project on simulator or device

No external packages are required — 100% SwiftUI-native.

---

## 🎯 Future Features

- Export coffee journal as PDF
- Lock screen widget for latest check-ins
- Shareable coffee cards with photos and stats
- Regional origin map visualization

---

## 💚 Built by Robert Ruelas

Enjoy your journey through every roast, region, and brew. ☕
