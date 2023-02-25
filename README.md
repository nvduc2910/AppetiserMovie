# Appetiser development challenge

Hi there, thanks for spending the time to review my assignment and I hope you will enjoy (reviewing) it. Your comments are much appreciated regardless of the result so please help me understand what I should improve in the future.

## 1. Wireframe and app design
<img width="1046" alt="image" src="https://user-images.githubusercontent.com/12984583/221218178-183ac344-2a08-48c0-ada7-95f5cba833ea.png">


## 2. Architecture

<img width="910" alt="image" src="https://user-images.githubusercontent.com/12984583/221214803-fbc27f93-c68d-4aa8-9044-6579dc58d7cb.png">


The application is using MVVM-C as main archiecture with RxSwift to build the features and Input/Output stream approach. It's quite similar to the traditional version, just that using Input/Output helps us make the responsibility clearer. 

The main reason make me choose the MVVM-C because we don't want to massive view controllers moving the logic to the View Model and every layer will be injected each other via protocol (the main princial for writing the testing and easy to managing and scaling)

- **Input**: Receive user interaction events such as searching, favorite movie item.
- **Output**: Provide all the data for View to visualize and bind the data to View (list of movie items, showing loading indicator, error message...)
- **Coordinator**: Handle UI navigation. (Following Single Responsibility design pattern)

## 3. Code structure - modules
### AppetiserMovie
This consists of files being used in the main target.
- **Extensions**: Extend some existing classes/structs such as UIView, Collection...
- **DesigSystem**: Implement the components, UI element, styles which is using across through the app such as DSText, DSColor, DSStateView, etc.
- **Networking**: Base API service for getting the and interacting with the BE using Alamofile library to call API. Handling and parsing the response as generic model responses passed.
- **Services**: All the API services to interact with BE. Each service need to conform from base Networking.
- **Features**: The feature modules contain all the screens. Every screens are following the MVVM archiecture.
- **Resources**: Contain all the resources such as font, assets, localization, strings, etc
- **Coordinator**: Base coordinator for handling the navigation between screens.
- **Model**: Represents real state content.
### AppetiserMovieTests
This contains all unit tests, mock classes and extensions that being used in unit tests

### AppetiserMovieUITests
This contains all component acceptance tests (aka UI tests).

## 4. Persistence
Using `NSUserDefault` for caching the movie items. That was handling by writing a base cache service with generic data type and inject to ViewModel via protocol therefore it's really easy to upgrade the code base when need to change to another cache type such as Realm, CoreData, SQLite, etc.


## 5. Main third-party libraries
Below is the list of third-party libraries that I use in the project:
- **RxSwift**: It is this project's backbone to seamlessly manipulate UI events (binding between ViewModel and View) as well as API requests/responses. By transforming everything to a sequence of events, it not only makes the logic more understandable and concise but also helps us get rid of the old approach like adding target, delegates, closures which we might feel tedious sometimes.
- **Alamofire/RxSwift**: To encapsulate API calls in a reactive way by taking advantage of RxSwift.
- **SnapKit**: To write auto-layout code easier.
- **SwiftGen**: SwiftGen is a tool to automatically generate Swift code for resources of your projects (like images, localised strings, etc), to make them type-safe to use.
- **Kingfisher**: For downloading and caching images.
- **Action**: This library is used with RxSwift to provide an abstraction on top of observables: actions and mostly I use it for subscribing the api status like receiving data or error when finishing an api call.

## 6. Build the project on local
After cloning the repo, please run `pod install` or `arch -arch x86_64 pod install ` if you're using M1/M2 from your terminal then open `AppetiserMovie.xcworkspace` and try to build the project using `Xcode 14`. It should work without any additional steps.

When running UI test, please make sure the hardware keyboard is disconnected (Simulator --> Hardware --> Keyboard --> Toggle off **Connect Hardware Keyboard**).

## 7. Tech stack checklist
- [x] Programming language: Swift
- [x] Design app's architecture: MVVM-C 
- [x] DesignSystem model for consitency the UI/UX through the app and easy to change the app style and apply dark/light mode.
- [x] UI matches in the attachment 
- [x] Exception handling
- [x] Code testable
- [x] Caching handling
- [ ] Accessibility for Disability supports
- [ ] Unit tests
- [ ] Acceptance tests

## 8. Feature checklist
- [x] Show movie list
- [x] Searching a movie by keyword
- [x] Favorite/Unfavorite a movie
- [x] Favorited movie list
- [x] Movie detail
- [x] Offline mode
- [x] Handle conner cases (search empty/ server error/ networking error)

<iframe src="https://www.veed.io/embed/42851821-4225-4427-b2a9-8a9f0ea5af54" width="744" height="504" frameborder="0" title="Simulator Screen Recording - iPhone 14 Pro - 2023-02-25 at 11.22.43.mp4" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>

Thanks and have a nice day ahead.
