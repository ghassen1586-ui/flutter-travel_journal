# 🧳 Travel Journal: Shared State with Provider

A small Flutter app I built to learn **state management with Provider**. You can browse Tunisian destinations, mark favorites with a ♥, and see them on a separate **My Trips** screen. Every screen stays in sync without passing data through constructors.

> Built as part of my Flutter course (Session 4: Shared state with Provider).

---

## ✨ Features

- **Explore screen**: a list of destinations (Djerba, Tozeur, Sousse, Tabarka, Kairouan)
- **Favorites ♥**: tap a heart, and the card and the AppBar badge update together
- **My Trips screen**: lists your favorites, lets you remove one, or clear them all
- **Fake API loading**: destinations load from a simulated service with 3 states:
  - ⏳ **loading**: a spinner while "fetching"
  - ❌ **error**: an error message with a **Retry** button (the fake service fails 1 time in 2 on purpose)
  - ✅ **done**: the list
- **Optimized rebuilds**: the AppBar rebuilds only when the favorites **count** changes (`context.select`)

---

## 🏗️ Project structure

```
lib/
├── main.dart                         # App entry + MultiProvider setup
├── models/
│   └── destination.dart              # Plain data class + sample data
├── services/
│   └── destination_service.dart      # Fake network call (delay + random failure)
├── providers/
│   ├── favorites_provider.dart       # Favorites state (toggle, clear)
│   └── destinations_provider.dart    # Loading state (loading / error / done)
├── screens/
│   ├── explore_screen.dart           # Main list + badge + loading states
│   └── my_trips_screen.dart          # Favorites list + clear all
└── widgets/
    └── destination_card.dart         # One destination with its ♥ button
```

Each folder has a single job: **models** describe data, **services** fetch it, **providers** hold the app state, and **screens/widgets** only display it.

---

## ⚙️ How it works

```
MultiProvider                  ← providers live ABOVE the whole app
└── MaterialApp
    ├── ExploreScreen          ← watches: favorites count + loading status
    │   └── DestinationCard    ← watches: "am I a favorite?"  reads: toggle()
    └── MyTripsScreen          ← watches: the favorites list   reads: toggle(), clear()
```

**What happens when you tap ♥:**

```
tap ♥ → context.read().toggle() → state changes → notifyListeners()
      → every widget that watches the provider rebuilds
        (the card, the AppBar badge, and My Trips)
```

No widget uses `setState`. All screens are `StatelessWidget`s: the state lives in the providers, and the UI just **reacts** to it.

---

## 🧠 What I understood

### 1. The problem: prop drilling
Before this session, if two widgets needed the same data, I had to keep it in a parent and pass it down through constructors, plus pass callbacks like `onToggle`. With more screens, this becomes messy and hard to maintain.

### 2. The solution: one central place for the state
A `ChangeNotifier` class holds the data and the methods that change it. The data is **private** (`_names`), so the only way to modify it is through methods like `toggle()` and `clear()`. This keeps the logic in one place.

### 3. `notifyListeners()` is what makes the UI update
After any change, the provider must call `notifyListeners()`. If I forget it, the screen silently never updates, with no error. That was the most important thing to remember.

### 4. `watch` vs `read`
The rule I keep in mind: **watch to SHOW, read to DO.**

| | Where I use it | Why |
|---|---|---|
| `context.watch<T>()` | inside `build()` | Displays data and rebuilds when it changes |
| `context.read<T>()` | inside `onPressed` / `onTap` | Calls a method once, without listening |
| `context.select<T, R>()` | inside `build()` | Rebuilds only when one specific value changes |

### 5. Where you put the provider matters
Because the providers are registered **above `MaterialApp`**, every screen can reach them, even screens opened later with `Navigator.push`. That's why `MyTripsScreen` receives nothing in its constructor and still shows the right data.

### 6. Handling async data like a real app
The `DestinationsProvider` taught me how real apps load data from an API:
- call `notifyListeners()` **twice**: once to show the spinner, once to show the result
- handle failure with `try/catch` and give the user a **Retry** button
- call `load()` **once**, in the provider's `create`, never inside `build()` (otherwise it would run on every rebuild)

### 7. Debugging lessons
- After adding a **new provider**, hot reload isn't enough. You need a **hot restart (`R`)**.
- `ProviderNotFoundException` means the provider is missing or placed below the widget that reads it.
- Using `watch` inside a callback causes an error. Callbacks use `read`.

---

## 💡 How it benefits me

- I can now build apps where **multiple screens share data cleanly**, which almost every real app needs (cart, login state, settings, favorites…).
- I learned to **separate concerns**: data, logic and UI each live in their own layer. This makes code easier to read, test and extend.
- The loading/error/done pattern is exactly what I'll use when connecting a **real backend API**.
- I understand *why* rebuilds happen, so I can write apps that are **more efficient** (`select` instead of `watch` when possible).
- It's a solid base before learning other state management solutions like **Riverpod** or **Bloc**, which build on the same ideas.

---

## 🚀 Run it locally

**Requirements:** Flutter SDK (3.x or later)

```bash
git clone https://github.com/ghassen1586-ui/flutter-travel_journal
cd travel_journal
flutter pub get
flutter run
```

To run it as a Windows desktop app:

```bash
flutter run -d windows
```

> The first load fails 50% of the time **on purpose** to show the error state. Just tap **Retry**.

---

## 🛠️ Tech

- **Flutter** / **Dart**
- **[provider](https://pub.dev/packages/provider)** for state management
- **Material 3** UI