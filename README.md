# README
# MarvelWallapop

## Decisions and Approach

### 1. Architecture: MVP with Coordinators (Following MVP and Clean Architecture)

I decided to maintain the existing **MVP (Model-View-Presenter)** architecture but introduced **Coordinators** to handle navigation. This improves separation of concerns and makes the navigation flow more scalable and testable. Additionally, I adopted principles from **Clean Architecture** to ensure a modular, flexible, and testable structure.

#### Why MVP?
The **MVP** architecture was chosen because it provides a clear separation of concerns between the UI, business logic, and data. It allows the Presenter to handle all the logic and delegate UI updates to the View. This ensures that the **View** is purely responsible for UI updates and doesn’t contain business logic, which aligns with the principle of **Single Responsibility**. Additionally, MVP makes it easier to implement and maintain patterns like **Unit Testing** and **Test-Driven Development (TDD)**, since the Presenter is decoupled from the view.

Another key reason is that MVP allows continuity in adhering to established patterns across different parts of the app. This consistency in architecture facilitates a scalable approach as the app grows, ensuring that changes in one part of the system don't heavily impact others.

#### Why Use Coordinators?
**Coordinators** were introduced to handle navigation in a more modular way. Traditionally, navigation logic can become spread across many view controllers, leading to tightly coupled code that is hard to maintain. By centralizing navigation in Coordinators, it is easier to manage transitions, reuse navigation flows, and ensure that navigation remains testable.

Coordinators also help to:
- Decouple navigation logic from view controllers, making the view controllers more focused on their main job: displaying content.
- Improve the testability of the app by allowing navigation flows to be tested in isolation.
- Enable more complex and scalable navigation structures, like deep linking or complex workflows, without cluttering the view controllers with this responsibility.

#### Use of Adapters
In this architecture, I used **Adapters** to facilitate the conversion of data between layers. **Adapters** are used to map the model data into a format that can be easily displayed by the view (for example, converting raw data from the model into a form that the `UICollectionView` can understand). 

The use of **Adapters** helps:
- Decouple the **Model** layer from the **View** layer. This allows for easy changes in the model representation without affecting the UI directly.
- Provide flexibility, as the Adapter can be modified without requiring changes to the View or Presenter, enhancing maintainability.
- Promote reusability, as the same adapter can be used in different parts of the app where similar data is displayed.

#### Migration from `Result` to `async/await` with `throws`
To modernize and simplify error handling in the app, I migrated from the `Result` type to `async/await` with `throws`. The **async/await** syntax is now the recommended approach for handling asynchronous operations in Swift, and it provides a more readable and concise way to work with asynchronous code.

The migration involved:
- Replacing **completion handlers** that used `Result` with `async` methods.
- Wrapping asynchronous code in **`throws`** to handle errors more intuitively, making it easier to catch and handle errors without having to check `Result` types manually.
- This simplifies error propagation and ensures that error handling remains consistent across the app. Now, functions that perform network requests or other asynchronous tasks simply throw errors that can be caught using `do-catch` blocks, improving clarity and reducing the cognitive load on developers.

This migration improves the overall code quality by making the async code more straightforward, leveraging modern Swift features to handle concurrency and errors effectively.

---

### 2. Character Detail View: `UICollectionViewCompositionalLayout`
For the **character detail view**, I implemented a `UICollectionView` using `UICollectionViewCompositionalLayout`. This approach avoids using a `UIScrollView` or nesting multiple `UICollectionView`s, which can lead to complex development and performance issues.

### 3. Search: Combine with Debounce
For the **search functionality**, I utilized `Combine` with a `debounce` operator. This helps improve search performance by reducing the number of API calls while the user is typing, providing a smoother experience.

---

This implementation ensures a modular, scalable, and performant approach to app development.
