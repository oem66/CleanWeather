CleanWeather 🌤️

A modern iOS weather application built with Apple WeatherKit and Clean Architecture principles, featuring MVVM pattern in the presentation layer.
📱 Features

Real-time weather data powered by Apple Weather Service
Current weather conditions with detailed metrics
10-day hourly forecasts for temperature, precipitation, wind, and UV Index
Minute-by-minute precipitation forecasts for the next hour
Severe weather alerts for supported regions
Location-based weather with CoreLocation integration
Clean, intuitive SwiftUI interface following Apple's design guidelines

🏗️ Architecture
This project implements Clean Architecture principles with clear separation of concerns:
Presentation Layer (MVVM)

Views: SwiftUI views for user interface
ViewModels: Observable objects managing UI state and user interactions
Models: Data models for presentation

Domain Layer

Use Cases: Business logic and weather data processing
Entities: Core weather domain models
Repository Interfaces: Abstractions for data access

Data Layer

WeatherKit Integration: Apple's native weather service
CoreLocation: Location services and geocoding
Repository Implementations: Concrete data access implementations

🔧 Requirements

iOS 16.0+ / iPadOS 16.0+ / macOS 13.0+ / tvOS 16.0+ / watchOS 9.0+
Xcode 14.0+
Swift 5.7+
Apple Developer Program membership (required for WeatherKit access)

⚡ Installation
1. Clone the Repository
bashgit clone https://github.com/oem66/CleanWeather.git
cd CleanWeather
2. Configure WeatherKit
Developer Account Setup:

Sign in to Apple Developer Portal
Navigate to Certificates, Identifiers & Profiles
Click Identifiers → App IDs
Register your app's bundle ID
Enable WeatherKit capability in the Capabilities section

Xcode Configuration:

Open the project in Xcode
Select your target in Project Navigator
Go to Signing & Capabilities tab
Click + Capability and add WeatherKit
Ensure your team and bundle identifier are properly configured

3. Build and Run

Open CleanWeather.xcodeproj in Xcode
Select your target device or simulator
Build and run the project (⌘ + R)

🔑 WeatherKit Usage Limits
WeatherKit provides:

500,000 API calls/month included with Apple Developer Program membership
Additional subscription plans available:

1 million calls/month: $49.99 USD
2 million calls/month: $99.99 USD



🏛️ Project Structure
CleanWeather/
├── Presentation/
│   ├── Views/
│   │   ├── WeatherView.swift
│   │   ├── ForecastView.swift
│   │   └── LocationView.swift
│   ├── ViewModels/
│   │   ├── WeatherViewModel.swift
│   │   └── LocationViewModel.swift
│   └── Models/
│       └── WeatherDisplayModel.swift
├── Domain/
│   ├── UseCases/
│   │   ├── GetCurrentWeatherUseCase.swift
│   │   └── GetForecastUseCase.swift
│   ├── Entities/
│   │   └── Weather.swift
│   └── Repositories/
│       └── WeatherRepositoryProtocol.swift
├── Data/
│   ├── Repositories/
│   │   └── WeatherRepository.swift
│   └── Services/
│       ├── WeatherService.swift
│       └── LocationService.swift
└── Resources/
    ├── Assets.xcassets
    └── Info.plist
🛠️ Technologies Used

SwiftUI: Modern declarative UI framework
WeatherKit: Apple's native weather data service
CoreLocation: Location services and geocoding
Combine: Reactive programming for data binding
Swift Concurrency: Async/await for asynchronous operations

🏗️ Clean Architecture Benefits

Separation of Concerns: Each layer has a single responsibility
Testability: Business logic is independent of UI and external dependencies
Maintainability: Easy to modify and extend individual components
Independence: UI, database, and external services can be changed independently
Scalability: Architecture supports growing complexity

📝 Attribution Requirements
When using WeatherKit in production, you must:

Display the Apple Weather trademark clearly
Include legal attribution links to data sources
Link weather alerts to Apple's weather alert details page

🤝 Contributing

Fork the repository
Create a feature branch (git checkout -b feature/amazing-feature)
Commit your changes (git commit -m 'Add amazing feature')
Push to the branch (git push origin feature/amazing-feature)
Open a Pull Request

📄 License
This project is available under the MIT License. See the LICENSE file for more information.
🙏 Acknowledgments

Apple for providing the WeatherKit framework
The iOS development community for Clean Architecture best practices
Contributors and testers who help improve this project

📞 Contact
For questions or support, please open an issue on GitHub or contact the maintainer.

Note: This app requires an active Apple Developer Program membership to access WeatherKit services. The app will not function without proper WeatherKit configuration.
