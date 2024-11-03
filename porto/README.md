# 🖼️ Portfolio App – App Level Details

Welcome to the detailed guide for the Portfolio App! This app allows users to securely store and update their professional information with a user-friendly interface. Let’s explore its capabilities and setup instructions.

## 🛠️ Functionalities

### Authentication
- **Signup/Login/Logout**: Secured by Firebase Authentication, ensuring only authorized access to the app.

### Portfolio Management
- **Create, Read, Update, Delete (CRUD)**: Users can easily manage their data, adding new skills, editing information, or removing outdated details as needed.

### Real-Time Database
- **Cloud Firestore**: Data is stored securely in the cloud, offering a seamless experience with real-time updates whenever users modify their portfolio.

## 📱 User Interface
A clean, visually appealing UI designed to prioritize readability and professional aesthetics, helping users create a portfolio that stands out.

## 🔧 Setup Instructions

### Prerequisites
- **Flutter SDK** installed on your system
- **Firebase Project**: Configure Firebase for Authentication and Firestore Database.

### Firebase Setup
1. Go to [Firebase Console](https://console.firebase.google.com/), create a project, and register the app.
2. Enable **Authentication** (Email/Password) and set up **Cloud Firestore**.
3. Download the `google-services.json` file and add it to the `android/app` directory.
4. Run `flutter pub get` to fetch the dependencies.

### Installation
1. Clone the repository:
  ```bash
   git clone https://github.com/shivam-1810/Portfolio-App.git
   ```
2. Navigate to the app directory:
  ```bash
   cd porto
   ```
3. Install dependencies:
  ```bash
   flutter pub get
   ```
4. Run the app:
  ```bash
   flutter run
   ```
## 🎉 Thank You!

Thank you for taking the time to explore this repository! I hope it proves valuable in showcasing how a professional portfolio can be managed with Flutter and Firebase.
