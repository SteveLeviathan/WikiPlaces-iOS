# WikiPlaces-iOS

**WikiPlaces** is a companion app to add places and deep link into the **Wikipedia** app with its coordinates to navigate to on the Places map to see interesting spots nearby. 

## Setup
- Clone the Git repo: `https://github.com/SteveLeviathan/WikiPlaces-iOS.git`
- Open `WikiPlaces.xcodeproj` in Xcode
- Build and run
- Run unit tests

## Functionality
- The main screen shows a scrollable list of places fetched from `GET https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json`
- Tapping on a place will **deep link** into the **Wikipedia app** if it is installed.
  - Opens the Places tab.
  - Navigates to the place with its coordinates.
  - Performs a place search to show interesting spots nearby.
- User can add a custom place to the list by providing
    - Name (optional)
    - Latitude
    - Longitude
- Error handling on 
  - main screen
  - sheet to add custom place
- Accessibility support

## Wikipedia iOS app

This WikiPlaces iOS app deep links into the Wikipedia iOS app. It depends on new functionality that can be functionally tested by cloning the forked repo and installing the Wikipedia app next to the WikiPlaces app.
- Clone forked repo: https://github.com/SteveLeviathan/wikipedia-ios
- Follow setup instructions before opening in Xcode
- Build and run


## Technincal details

### Modern technology
- SwiftUI
- Swift concurreny: Async Await
- iOS 17+

### SwiftUI + VIP architecture

The main screen can be found in the **PlacesList** folder. For a clear separation of concerns, the app uses the VIP architecture:

- Configurator
- View(Model)
- Interactor
- Presenter
- Router

### Protocol oriented design
The protocol oriented design enables dependency inversion and improves testability. Mocks can be easily created. Dependencies are all injected. 
Dependencies additional to the VIP flow:

- **APIClientType**: Providing an interface to an API Client
- **APIRouteType**: Providing an interface to API routes
- **DeepLinkType**: Providing an interface to deep links
- **UIApplicationType**: Providing an interface to UIApplication for injection and mocking
- **CoordinateValidatorType**: Providing an interface to a coordinate validator

### Extensibility
Although this is a small app, the following have been set up to be easily extensible:

- **APIClient:** Can be easily extended to support more HTTP methods besides `GET` and `POST`.
- **APIRouteType:**
    - **LocationsAPIRoute** can be extended with more endpoints
    - Any new domain specific API route can be created by conforming to APIRouteType  
- **DeepLinkType:**
  - **DeepLink** can be extended with more types of deep links
  - Any new domain specific deep link can be created by conforming to DeepLinkType

### API
**Locations are fetched from:**
`GET https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json`

**Response:**
```
{
    "locations": [
        {
            "name": "Amsterdam",
            "lat": 52.3547498,
            "long": 52.3547498
        },
        {
            "lat": 52.3547498,
            "long": 52.3547498
        }
    ]
}
```

**Response is decoded to:**
- LocationsResponse
- Location

### Deep linking

The app supports a deep link to the Wikipedia iOS app, into the Places screen. It takes these parameters:
- name
- latitude
- longitude

Example:
`wikipedia://places?name=Amsterdam&latitude=52.3547498&longitude=4.8339215"`

### Testing
Unit tests have been written for:

- **PlacesList** VIP flow:
  - PlacesListConfiguratorTests
  - PlacesListInteractorTests
  - PlacesListPresenterTests
  - PlacesListRouterTests
  - PlacesListViewModelTests
  - Mocks
    - PlacesListInteractingMock
    - PlacesListPresentingMock
    - PlacesListRoutingMock
    - PlacesListDisplayingMock
-  Dependencies
    - LocationsAPIRouteTests
    - CoordinateValidatorTests
    - DeepLinkTests
    - Mocks:
      - APIClientTypeMock
      - CoordinateValidatorTypeMock
      - UIApplicationTypeMock
 
