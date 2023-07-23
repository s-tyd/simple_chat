# Portfolio: Simple Chat Application

## Technical Overview

This chat application is developed predominantly using Firebase and Riverpod for state management, along with Hive for
local data storage. Here is a detailed explanation of the core technologies and their roles:

### Firebase

Firebase is a suite of cloud services developed by Google. It provides a range of tools such as a NoSQL database (Cloud
Firestore), user authentication service (Firebase Authentication), and a file storage solution (Firebase Storage).

- **Cloud Firestore**: A NoSQL database used to store user information, chat rooms, messages, etc.
- **Firebase Authentication**: Provides authentication services using an email/password and Google account for social
  logins.
- **Firebase Storage**: Used for tasks like uploading profile pictures.

### Riverpod

Riverpod is a state management library for Flutter. It's used to share and manage states within the application.
Specifically, it works in conjunction with Firebase to manage states such as user information, friend lists, and chat
rooms.

### Hive

Hive is a lightweight and fast key-value store designed for Flutter. It is used as a local data storage for the
application. Specifically, it is used to cache friend lists and chat rooms for offline access.

## Architecture

The Repository Pattern is used to separate data access logic
and business logic. Specifically, access to Firestore and Hive is conducted through repositories, and business logic (
such as state management) is managed by respective providers. This design enhances code reusability and testability.

This chat application uses modern technology to provide a consistent user experience, thanks to the adoption of
contemporary architecture and state-of-the-art technology.

## Future Improvements
The following improvements are being considered for future development:

1. **Addition of Base Repository**: Concentrate the common data access logic in a Base Repository.
2. **User Added Notifications**: Implement notification features and pending displays when a user is added.
3. **Room Infinity Scroll**: Implement infinite scrolling for messages. This may also depend on the amount of local data.
4. **Addition of Splash Screen**: Add a splash screen at app startup, and prefetch necessary data (e.g., admin user data).
5. **Addition of User Profile Images**: Support uploading and displaying user profile images.
6. **Addition of Talk Room Icons**: Add icons to the talk rooms.
7. **Open Corresponding Talk Room by User Tap**: Add a feature to open the corresponding talk room when tapping a username.
8. **Multi-user Talk Room**: Implement a feature that allows the creation of talk rooms with multiple users.
9. **ID Barcode Reading**: Implement a feature to read user IDs with barcodes.
10. **Multilingual Support**: Localize the application for multiple languages.
11. **Image, Video Sending**: Support sending images and videos.
12. **Account Linking with Email**: Implement a feature to link accounts using an email address.
13. **Linking Message List to Room with Hive**: Use Hive to save the message list of each talk room locally.
14. **Addition of Unit Tests**: Implement comprehensive unit testing for all application functions to ensure code reliability and prevent bugs.
15. **Addition of ViewModels to All Views**: Incorporate the ViewModel architecture pattern in all views for efficient state management and separation of business logic.
16. **Dark Mode and Light Mode Switching**: Allow users to switch between dark and light themes based on their preference.
17. **Push Notification Implementation**: Ensure that users don't miss out on new messages and updates by implementing push notifications.
18. **Offline Support**: Make some features of the application usable even when there is no network connection.
19. **Gathering User Reviews and Feedback**: Make it easy to collect feedback from users to facilitate improvements in the app.
