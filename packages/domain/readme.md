# Domain Package

The domain package is the core of our application, implementing the principles of Clean Architecture and Clean Code.
This package contains the business logic and rules of the application, independent of any external frameworks or
implementation details.

## Minimal Dependencies

The domain package has minimal dependencies, only relying on
the `dart:core`, `equatable`, `typed_data`, `binary_data_reader` libraries. This ensures that the core
business logic is not tied to any specific framework or external concerns.

## Key Components

1. **Entities**: Core business objects encapsulating the most general and high-level rules.

2. **Use Cases**: Application-specific business rules that orchestrate the flow of data to and from entities.

3. **Repository Interfaces**: Abstract interfaces defining data operations, adhering to the Dependency Inversion
   Principle.

4. **Value Objects**: Immutable objects modeling domain concepts and encapsulating related attributes and behaviors.

5. **Domain Services**: Contain domain logic that doesn't naturally fit within a single entity or value object.

6. **Exceptions**: Domain-specific exceptions thrown by entities, use cases, or domain services.

## Clean Architecture and Dependency Inversion

This package follows Clean Architecture principles by:

- Keeping business logic independent of external concerns (UI, database, frameworks).
- Defining abstract interfaces (e.g., repository interfaces) that higher-level modules depend on, rather than concrete
  implementations.
- Ensuring that the domain layer doesn't depend on any other layer of the application.

By adhering to these principles, we achieve:

- Better testability: Business logic can be tested in isolation.
- Improved maintainability: Changes in external layers don't affect the core business logic.
- Enhanced flexibility: We can easily swap implementations (e.g., data sources) without affecting the business rules.

This separation allows for code reusability across different projects or platforms while maintaining a clear separation
of concerns throughout our application.
