Full Project – Exam PG5602

This project was developed as part of the exam in the course PG5602 at Kristiania University College.

It is a native iOS application called NewsWorldwide, where users can explore global news, filter by category, and search for articles using NewsAPI. 
Articles are displayed with titles, descriptions, and publication dates.

---

## 📁 Project Structure
```
NewsWorldwide/
├── NewsWorldwide/          # Main app source files
├── NewsWorldwide.xcodeproj # Xcode project file
├── .gitignore              # Git ignore file
```

---

## 🚀 Technologies Used

iOS Application (Swift + SwiftUI)
- Swift 5
- SwiftUI (for UI layout and navigation)
- SwiftData (for local persistence)
- Async/Await (for async network requests)
- URLSession (for API integration)
- Keychain (for secure storage of the API key)
- API Integration
- NewsAPI.org – Used to fetch news articles

---

🛠️ How to Run Locally

### 🔹 Prerequisites
- macOS with Xcode installed (Xcode 15 or newer recommended)
- A valid NewsAPI.org API key

### 🔹 Setup Instructions
1. Clone the repository
```
git clone https://github.com/Lido1997/full-project-exam-PG5602.git
cd full-project-exam-PG5602
```

2. Open in Xcode
```
open NewsWorldwide.xcodeproj
```

3. Insert your NewsAPI API key
- On first launch, the app will prompt for an API key.
- This key is securely stored using the Keychain API and used in subsequent sessions.

4. Run the app
- Select a simulator or a connected device.
- Press Cmd + R or click Run in Xcode.
