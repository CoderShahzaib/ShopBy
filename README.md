# 🛍️ ShopBy - Flutter E-Commerce App

ShopBy is a modern **E-Commerce App** built with **Flutter** using **MVVM architecture**.  
It integrates **Firebase Authentication, Firestore, and Realtime Database** for secure and scalable backend support.  
State management is handled with **Riverpod** to keep the app clean, testable, and maintainable.  

---

## ✨ Features
- 📱 **Flutter MVVM architecture** (separation of UI & business logic)
- 🔑 **Firebase Authentication** (Sign up, Login, Logout)
- 🛒 **Product listing & details**
- 📊 **Realtime Database** & **Firestore** integration
- 🌙 Clean and responsive UI
- ⚡ Powered by **Riverpod state management**

---

## 🛠️ Tech Stack
- **Frontend:** Flutter (Dart)
- **State Management:** Riverpod
- **Backend:** Firebase  
  - Authentication  
  - Firestore Database  
  - Realtime Database  

---

## 🚀 Getting Started
Follow these steps to run the project locally:

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed
- A Firebase project with:
  - `google-services.json` (Android)
  - `GoogleService-Info.plist` (iOS)
  - `firebase_options.dart` (generated via `flutterfire configure`)

### Installation
1. Clone the repo:
   ```bash
   git clone https://github.com/CoderShahzaib/ShopBy.git
   ```
2. Navigate into the project folder:
   ```bash
   cd ShopBy
   ```
3. Get the dependencies:
   ```bash
   flutter pub get
   ```
4. Add your Firebase configuration files:
   - `lib/firebase_options.dart`
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
5. Run the app:
   ```bash
   flutter run
   ```

---

## 📂 Project Structure (MVVM)
```
lib/
├── models/        # Data models
├── view/          # UI Screens
├── view_model/    # Business logic & state management
├── services/      # Firebase & API services
└── widgets/       # Reusable UI components
```

---

## 🔒 Important Note
For security reasons:
- `firebase_options.dart`
- `google-services.json`
- `GoogleService-Info.plist`

are **not included** in this repository.  
You must add your own Firebase config files to run the project.

---

## 📸 Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/33523252-af7a-4b9f-a457-0228f94cd02b" width="30%" />
  <img src="https://github.com/user-attachments/assets/cecd1864-ca3e-4790-96e3-ff3966875967" width="30%" />
  <img src="https://github.com/user-attachments/assets/90cb8b4e-4750-421b-9a7e-5aae4e4e162b" width="30%" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/7b20ca07-6eb7-4fd0-9492-02148710bce6" width="30%" />
  <img src="https://github.com/user-attachments/assets/2a1b1243-9861-407d-9b21-8bfc8d587c82" width="30%" />
  <img src="https://github.com/user-attachments/assets/0d7b9d58-2572-4874-b6ba-eabdced0f3b5" width="30%" />
</p>

<p align="center">
  <img width="492" height="1055" alt="Screenshot 2025-09-06 131054" src="https://github.com/user-attachments/assets/ca1fcb39-3479-4ed0-ae53-d8b3333b60f5" width="30%"/>
  <img width="489" height="1066" alt="Screenshot 2025-09-06 131112" src="https://github.com/user-attachments/assets/035122ac-ad58-4050-bc0b-c1d8d0a47960" width="30%"/>
  <img width="491" height="1063" alt="Screenshot 2025-09-06 131130" src="https://github.com/user-attachments/assets/b46122d6-fde9-44d3-91c8-5ce98467c796" width="30%"/>
</p>

<p align="center">
  <img width="490" height="1062" alt="Screenshot 2025-09-06 131155" src="https://github.com/user-attachments/assets/54642b3a-8730-4eb5-aad7-6b55593a835b" width="30%"/>
  <img width="490" height="1050" alt="Screenshot 2025-09-06 131334" src="https://github.com/user-attachments/assets/eb848209-160b-48b4-a028-6015b1d7557a" width="30%"/>
  <img width="491" height="1065" alt="Screenshot 2025-09-06 131349" src="https://github.com/user-attachments/assets/eb330d52-1887-40d0-9e20-dfe788171c20" width="30%"/>
</p>

---

## 👨‍💻 Author
**Shahzaib Jillani (CoderShahzaib)**  
Flutter Developer | Firebase Enthusiast  

🔗 [GitHub](https://github.com/CoderShahzaib)  

---

⭐ If you like this project, give it a star on GitHub!
