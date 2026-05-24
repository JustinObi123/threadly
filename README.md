# Threadly

A multi-vendor clothing marketplace built in Flutter, with Firebase as the
backend. Customers shop from many independent vendors in a single cart,
vendors run their stores from a dedicated app, and an admin web panel manages
the platform. Inspired by ASOS, Depop, and StockX in style.

> **Status:** Phase 1 — customer app shell with auth, browsable catalog,
> product detail, cart, and profile. Vendor/driver/admin apps are scaffolded
> as placeholders. Payments, real checkout, and delivery come in later
> phases.

---

## What's in this monorepo

```
flutter/
├── apps/
│   ├── customer_app/   # Shopper app — Android, iOS, Web (the working one)
│   ├── vendor_app/     # Seller app  — placeholder
│   ├── driver_app/     # Delivery driver app — placeholder
│   └── admin_web/      # Super-admin panel (Flutter Web) — placeholder
├── packages/
│   └── core/           # Shared models, repositories, theme, widgets, fonts, icons
├── tools/seed/         # Node script to seed sample products into Firestore
├── firebase.json       # Firebase project config
├── firestore.rules     # Role-based security rules (customer/vendor/driver/admin)
├── firestore.indexes.json
├── storage.rules
└── melos.yaml          # Monorepo workspace tooling
```

## Tech stack

- **Flutter** (stable) for all four apps
- **Riverpod 2.x** for state management
- **go_router** for navigation with auth guards
- **Firebase** — Auth, Firestore, Storage, FCM, Cloud Functions
- **Stripe** (Phase 3) — handled in Cloud Functions, never on the client
- **Melos** — monorepo workspace tool
- **Urbanist** font + SVG icon set (bundled in `packages/core/assets/`)
- **Theme tokens** — proper light + dark mode

---

## Prerequisites

| Tool | Version | Why |
|---|---|---|
| **Flutter SDK** | ≥ 3.22 stable | Build the apps |
| **Dart** | comes bundled with Flutter | |
| **Node.js** | ≥ 18 | Firebase CLI, seed script, Cloud Functions |
| **Firebase CLI** | latest | `npm install -g firebase-tools` |
| **FlutterFire CLI** | latest | `dart pub global activate flutterfire_cli` |
| **Melos** | latest | `dart pub global activate melos` |
| **Chrome** | latest | Easiest target to run the customer app |

Make sure `flutter`, `dart`, and the pub global bin (`~/.pub-cache/bin` or
`%LOCALAPPDATA%\Pub\Cache\bin` on Windows) are on your PATH.

---

## Setup — first time

```bash
# 1. Clone
git clone https://github.com/<your-username>/threadly.git
cd threadly

# 2. Bootstrap the monorepo (fetches deps for every package)
melos bootstrap

# 3. Create a Firebase project (one-time per developer)
#    Either run:
firebase projects:create my-threadly-dev --display-name "Threadly Dev"
#    OR create one in the console: https://console.firebase.google.com
firebase use my-threadly-dev
```

### 4. Enable the Firebase services

In the [Firebase Console](https://console.firebase.google.com) for your project, enable:

- **Authentication → Sign-in method → Email/Password**
  (and Google / Apple if you want, but Email/Password is enough to log in)
- **Firestore Database → Create database** (production mode, pick a region)
- **Storage → Get started** (production mode, same region)

### 5. Deploy security rules and indexes

```bash
firebase deploy --only firestore:rules,firestore:indexes,storage
```

### 6. Generate `firebase_options.dart` for the customer app

This file is **gitignored** because it's per-project. You generate your own.

```bash
cd apps/customer_app
flutterfire configure --project=my-threadly-dev
```

When prompted, pick platforms with **space** then **Enter** (web is the
quickest to run). For Android/iOS package IDs, use `com.threadly.customer`.

### 7. (Optional) Seed sample products

The catalog is empty by default. To populate it with 8 demo products and 2
demo stores:

1. In the Firebase Console → **Project Settings → Service accounts** →
   **Generate new private key**. Save the JSON file somewhere **outside**
   the repo (the gitignore catches common patterns just in case).
2. Run the seed:

```bash
cd tools/seed
npm install
# macOS / Linux:
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/sa-key.json
# Windows PowerShell:
$env:GOOGLE_APPLICATION_CREDENTIALS = "C:\path\to\sa-key.json"
node seed.js
```

---

## Run the customer app

```bash
cd apps/customer_app
flutter run -d chrome      # web
# or
flutter run -d <device-id> # android/ios — flutter devices to list
```

First load opens the **Sign in** screen. Click **Create one**, sign up with
any email and an 8+ character password. You'll land on the home screen.

If the catalog is empty, you skipped step 7 (seed). The trending row may show
an index-building error the first time — Firestore takes 1–3 minutes to
build composite indexes. Refresh after a couple of minutes.

---

## What works in Phase 1

- Email/password sign-up + sign-in (Firebase Auth)
- Light + dark theme that follows the system OR the manual toggle in Profile
- Home screen — header, search bar, category carousel, banner, trending,
  new arrivals
- Catalog — search, category filter, sort (newest / price / best-selling /
  top-rated)
- Product detail — image gallery, size/color picker, add to cart
- Cart — real-time Firestore-backed, qty +/-, subtotal
- Favourites tab (UI shell)
- Wallet tab (UI shell with placeholder balance card)
- Orders tab (UI shell with status filters)
- Profile tab — sectioned settings, working Profile Information edit,
  working dark-mode switch, working log-out, every other tile lands on a
  placeholder screen with a back button

## What's coming

| Phase | Scope |
|---|---|
| 1b | Mobile Google sign-in, address management, real checkout button |
| 2  | Vendor app — onboarding, product CRUD, order list. Admin web — approvals, categories |
| 3  | Stripe checkout via Cloud Functions, order tracking screens |
| 4  | Driver app — delivery assignments, maps, status updates |
| 5  | Reviews, returns/refunds, coupons, vendor/customer chat |
| 6  | Analytics, Stripe Connect payouts, FCM, App Check, Sentry, landing page |

---

## Project conventions

- **Repositories live in `packages/core/lib/repositories/`** as abstract
  interfaces with Firestore implementations. The day you swap Firebase for a
  custom backend, only these files change.
- **Theme tokens via `Tokens.background(context)` / `Tokens.surface(context)` /
  `Tokens.textPrimary(context)`** — never hardcode `AppColors.background`
  in a widget. Brand colors (primary orange, navy accent, tile colors) stay
  in `AppColors` since they don't flip with theme.
- **Icons via `AppIcon(AppIcons.cart, size: 22, color: ...)`** — typed
  reference, never raw asset paths.
- **State management is Riverpod 2.x** — no Bloc, no Provider.
- **Models are plain Dart classes** for now (no `freezed`). Migrate later if
  needed.

## Security model

Cloud Functions (Phase 3+) handle all money-touching logic. The client never
holds Stripe secrets and never writes to `orders/`, `payments/`, `payouts/`
directly — `firestore.rules` blocks those writes. Role-based access uses
Firebase Auth custom claims (`customer` / `vendor` / `driver` / `admin`).

## Troubleshooting

| Symptom | Fix |
|---|---|
| `flutter` not on PATH | Add `<flutter>/bin` to user PATH, **open a new terminal** |
| `flutterfire: command not found` | `dart pub global activate flutterfire_cli`, ensure pub bin is on PATH |
| `This application is not configured to build on the web` | `flutter create . --platforms=web --project-name=customer_app` in the app folder |
| `[firebase_auth/invalid-credential]` on login | Account doesn't exist in your Firebase project — sign up first, or reset password in the Firebase Console |
| `The query requires an index` in trending row | Firestore is still building the index; wait 1–3 min and refresh |
| Web changes don't appear after restart | Hard refresh Chrome: **Ctrl+Shift+R** |

## License

MIT — see [LICENSE](LICENSE).
