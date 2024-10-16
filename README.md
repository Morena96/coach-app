k![Build Status](https://github.com/5Tul/coach_app/workflows/widget-test/badge.svg)
# FiyrCoach App For Administrators And Coaches

## Project Overview

Welcome to FiyrCoach! This application is designed to help coaches monitor and analyze the performance of athletes using data collected from GPS devices. The app provides insights and detailed performance metrics to assist coaches in making informed decisions.

## Project Structure

The project is organized into feature-specific modules. Each feature follows a standard folder structure to maintain consistency and readability throughout the codebase. Here is an example of the folder structure for a feature:

```
├── feature_name/
│ ├── data/
│ │ ├── repositories/
│ │ └── models/
│ ├── presentation/
│ │ ├── pages/
│ │ ├── widgets/
│ │ └── providers/
│ └── feature_name.dart
```

## Domain Layer (domain package)

The domain package in this project serves as the core of our application, implementing the principles of Clean Architecture and Clean Code. This package contains the business logic and rules of the application, independent of any external frameworks or implementation details. Here's an overview of its key components:

1. Entities: These are the core business objects of the application. They encapsulate the most general and high-level rules and can be used across different applications.

2. Use Cases: Also known as Interactors, these classes contain application-specific business rules. They orchestrate the flow of data to and from the entities and direct those entities to use their business rules to achieve the goals of the use case.

3. Repository Interfaces: These define abstract interfaces for data operations. The actual implementations of these interfaces are provided in the infrastructure layer, allowing for easy swapping of data sources without affecting the business logic.

4. Value Objects: Immutable objects that model concepts in our domain, encapsulating related attributes and behaviors.

5. Domain Services: These contain domain logic that doesn't naturally fit within a single entity or value object.

7. Exceptions: Domain-specific exceptions that can be thrown by entities, use cases, or domain services.

The domain package does not depend on any other layer of the application, ensuring that it remains pure and focused solely on the business rules. This separation allows for better testability, maintainability, and flexibility in our application architecture.

By keeping our domain logic separate and framework-independent, we can easily reuse this core business logic across different projects or platforms, promoting code reusability and maintaining a clear separation of concerns throughout our application.



## Creating a feature

This repo has bash file to create a feature with folder structure above. To use it you have to Make the Script Executable:

```
chmod +x new_feature.sh
```

Then, each time for a new feature run

```
./new_feature.sh hello_world
```

## Run code generation

Run once
```
flutter pub run build_runner build -d
```

Run in background
```
flutter pub run build_runner watch -d
```

## Run tests

Run tests on coach_app only
```
flutter test
```

Run tests on coach_app and app packages in /packages dir
```
sh scripts/run_all_tests.sh
```


## Project Guidelines

- Follow Flutter best practices and coding standards
- Comment major sections of the code for clarity
- Add necessary documentation to this file
- Cover with unit/widget tests and ensure all tests pass



## Search all non-localized strings
Text\(['"](.*?)['"]|title:\s*['"](.*?)['"]|label:\s*['"](.*?)['"]|hint:\s*['"](.*?)['"]|AppBar\([^)]*title:\s*['"](.*?)['"]


## Generate localizations
```
flutter gen-l10n 
```