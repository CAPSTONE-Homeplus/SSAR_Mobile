# 📋 HOME_CLEAN

Modern Flutter app helps apartment residents manage services, shared wallets, personal wallets and track spending.

## ✨ Features

🏢 Apartment Services: Browse and select various apartment-related services conveniently.<br>
✅ Service Tracking: Monitor the status of booked services from request initiation to completion, with real-time updates.<br>
💰 Shared Wallet Management: Manage a shared wallet for household expenses and track spending.<br>
👥 Shared Wallet Members: Manage members in a shared wallet with role-based access.<br>
💳 Personal Wallet: Maintain a separate personal wallet for individual expenses and transactions.<br>
🔔 Real-time Notifications: Get instant updates on wallet transactions, service bookings, and member activities.<br>
📱 User-friendly UI: Intuitive and responsive interface for smooth navigation.<br>
🌙 Dark Mode Support: Switch between light and dark themes for a comfortable user experience.<br>
🔄 Offline Access: Access essential wallet and service details offline, with automatic synchronization when back online.<br>
🚀 Optimized for apartment residents to simplify expense management and service bookings!  

## 📱 Screenshots

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code
- Git

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── base/
│   ├── constants/
│   ├── dependencies_injection/
│   ├── enums/
│   ├── exception/
│   ├── format/
│   ├── helper/
│   ├── request/
│   └── router/
├── data/
│   ├── datasources/
│   ├── mappers/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── bloc/
│   ├── screens/
│   └── widgets/
└── main.dart
```

## 🛠️ Technical Stack

- **Architecture**: Clean Architecture with SOLID principles
- **State Management**: flutter_bloc for predictable state handling
- **API Integration**: REST API with dio for HTTP requests
- **Navigation**: Uses GetX for efficient and reactive route management
- **Local Storage**: shared_preferences, flutter_secure_storage for simple data & hive for complex data
- **Dependency Injection**: get_it for service locator pattern
- **Testing**: Unit tests with mockito and Widget tests with flutter_test
- **Error Handling**: Centralized error handling with custom exceptions
- **Code Quality**: Strict lint rules and consistent code style

## 📊 Performance Optimization

- Lazy loading for images and data
- Memory management with proper widget lifecycle handling
- Minimized rebuilds using const constructors and efficient BLoC patterns
- Network caching for improved offline experience

## 🧪 Testing

```bash
# Run all tests
flutter test

# Generate coverage report
flutter test --coverage
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Authors

- **Nguyen Huu Bao** - [GitHub Profile](https://github.com/nguyenhuubao20)

## 🙏 Acknowledgements

- [Flutter Documentation](https://flutter.dev/docs)
- [Bloc Library](https://bloclibrary.dev/)
- [Material Design](https://material.io/design)

---

⭐️ Star this repo if you find it helpful!
