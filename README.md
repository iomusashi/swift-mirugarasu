![App Icon iOS](https://user-images.githubusercontent.com/1917005/171552448-33921334-6849-4f46-9b55-011ae44e5436.png)

# swift-mirugarasu
見るガラス – Mirror Glass (glass to see), an iTunes search client in iOS written in Swift for UIKit

## UI and Design

The UI concept was inspired by neumorphic glasses, so I used a lot of `Material` sheets which was introduced in iOS 15 from WWDC 2021.

`Material` in UIKit is available as a visual effect from the `UIVisualEffectView`, and you need two separate overlaying effect views to render both the material effect and vibrancy effect. The material effect is applied as a blur for the sheet, and the vibrancy effect is applied for all the visual elements on top of the sheet, so its colors blend slightly with the background. 

During this exercise, I found that doing this visual effect is more work in UIKit compared to working it on SwiftUI.

### Concept Design (Mirror Glass Figma)
![mirugarasu-concept](https://user-images.githubusercontent.com/1917005/171521961-b17c5054-1593-4548-8acf-db85480550b7.png)

Please see 見るガラス.fig, a Figma file which includes the mockup concepts I have designed for the app. I tried to replicate this concept in the app, but I have not achieved it at 100%. Most of the difficulties that I have faced during the coding exercise was due to my inexperience on programmatic UIKit.

### Actual Design (Implementation)

![mirrorglass-actual-light](https://user-images.githubusercontent.com/1917005/171554138-eca4b4f2-0011-48c3-976c-76b97fae3b6d.png)
![mirrorglass-actual](https://user-images.githubusercontent.com/1917005/171550020-f5e41e84-e0a7-4415-a7fd-a43d117c90fe.png)

In the actual implementation, I used colorful blobs that contrasts the background color, and to provide a highlight of blur and vibrancy for each card. For all screens, I made use of `UICollectionView` to provide a list interface, including the detail view. For all screens that show a list interface, I used the list configuration of the `UICollectionViewCompositionalLayout`.

For the history view, I used a custom `UICollectionViewLayout` that shows and behaves like a stack of cards. I have made and used this layout from my older projects.

The only screen that I have used an Rx reactive interface is at search, for the search bar functionality.

## Project File Organization

![Screen Shot 2022-06-02 at 12 02 59 PM](https://user-images.githubusercontent.com/1917005/171550844-282d4193-f2b4-4421-9a3b-a79e87a564f7.png)

Files are organized in the project as follows:
1. **Feature-specific files are grouped together.** This approach permits scalability. When adding a new feature, files that are created to build on that feature reside on a single parent group (folder). When removing a feature, you can simply remove the parent group of that feature, and all of the files associated with that feature will be removed as well. This is in contrast to grouping by type, as you need to manually determine which files are affected when you remove a certain feature.
2. **Files that are shared among different features, such as a model, are grouped by type.** Common files are ideally grouped by type as it would be easier to locate, and puts safety when removing files from an obsolete feature.

## Architecture: MVVM

The architecture that I have decided to used on this coding exercise is MVVM, due to a preference (or bias?) over the standard MVC architecture.

The responsibilities of each component in the architecture are as follows:
- Views – showing the user interface
- View Models (existential types) – provide values or view state to the view, and capture those values from the model (through a service or repository dependency)
- Models – these are the objects that model the domain

In this project, the view models are existential types, and not concrete types. This approach makes view models easier to test, as well as promotes the reusability of views. Views having concrete view model dependencies are difficult to reuse, and having concrete view models makes both of the view and the view model harder to test, as you can't swap a concrete view model with a mock during testing.

```swift
// ie. Concrete ViewModels
final class UserListController: UIViewController {
  var viewModel: UserListViewModel!
}
```
Concrete view models have a fixed type, and they can't be swap out anywhere in the implementation.
So it would be difficult to mock during test, and its view can't be reused when needed be.

Suppose that we have two different scenarios that require to show a list of users. In one, we need
to show a friends list, and the other one we need to show a ranking of users in a list.

If we create a view with a concrete view model, we need to create two different version of views that have each of their own view model and model dependencies. If we have another requirement that would require to show another list of users that don't fit the view model and model dependencies than what we have built in the past, we need to create another one to fit the purpose.

By using existential types, we eliminate this problem by having our views as dumb views. View models and their model dependencies can be changed since existential types are value abstractions, which means that we can swap view model and model dependencies as long as it satisfy the view model requirements of the view.

So for scenario 1 which requires a list of friends, we can assume that the view model should have a user model dependency, while in scenario 2, we can assume that the view model should have a rank object dependency.

```swift
// Suppose that we'll have a cell that we'll reuse to show the list of users such as:
final class UserCell: UICollectionViewCell {
  var viewModel: UserCellViewModelProtocol!
}

// A protocol which would define that our view models are existential types
// where a concrete view model value will be given at a later time
protocol UserCellViewModelProtocol {
  var userProfileImageUrl: URL? { get }
  var username: String { get }
}

// Scenario 1: Show the user a list of friends
// Also, it's important to note that view models should be reference types
class FriendCellViewModel: UserCellViewModelProtocol {
  var user: User // the model as a friend 😭
  init(user: User) {
    self.user = user
  }
}

extension FriendCellViewModel {
  var userProfileImageUrl: URL? { user.profileImageUrl }
  var username: String { user.username }
}



// Scenario 2: Show the user a rank of the most evil villains to walk the earth
class RankCellViewModel: UserCellViewModelProtocol {
  var rank: Rank // the model dependency
  init(rank: Rank) {
    self.rank = rank
  }
}

extension RankCellViewModel {
  var userProfileImageUrl: URL? { rank.user.profileImageUrl }
  var username: String { rank.user.username }
}



// So later on if you need to show a cell for the list of users, you'll use:
cell.viewModel = FriendCellViewModel(user: friend)

// and when the need to show a user for a rank arises, you'll use the same view:
cell.viewModel = RankCellViewModel(rank: mostEvilVillain)

// and to test this later, we can use a mock instead of a real one
class MockCellViewModel: UserCellViewModelProtocol { ... }
...
cell.viewModel = MockCellViewModel(user: mockUser)
expect(cell.viewModel).toNot(beNil())
```

## Persistence

The app persists tracks which have been previously fetched. The persistence framework uses vanilla CoreData.
Though the CoreData interfaces that I have created on this project are experimental (an approach that I haven't used yet in my projects) – tracks are persisted and are retrievable using an Sqlite data store.

In the project, the `Track` struct serves as the DTO (Data Transfer Object) which was serialised from JSON using Apple's `Codable` protocol.

In the data model, an equivalent has been created: `TrackEntity` which will serve as the table for the `Track` DTO.
The attributes of `TrackEntity` has the same properties of the `Track` struct, which are written in similar case.

### Why use different models for network and persistence?

The idea comes from the`Onion` architecture. ~~An architecture named onion because it makes you cry~~.
The onion architecture proposes that domain models, the models that you use in the app (akin to network models), should be separate from your infrastructure models (the model that is written in a database). The idea is to protect the app from any problems that arise in schema changes from the database (infrastructure models). Since the app is interacting with domain models, and changes to the infrastructure models won't or should not affect the app.

So in this project, the Codable object is what I used uniformly in the app, while the NSManagedObject are only interfaced by the Codable object itself when needed be.

Using `ManagedObjectSerializing` protocol, the domain model structs such as `Track` can be easily converted to its entity type (NSEntityDescription), which is then used to convert into NSManagedObject (the infrastructure mode).

### Struct and ManagedObject mapping

The experimental approach uses the Mirror API to map a struct to managedobject, and a static factory to map managedobject back to its struct equivalent.

This approach is somehow to what I was using on my older projects written in Objective-C: Mantle, MagicalRecords, and MTLManagedObjectSerializing – all are objc libraries who handle JSON and CoreData serializing effectively.

## Testing

Unit tests are included as well. I should have created this docs sooner, but since I no longer have the time, please see the `Test` folder in the project, and hit `Cmd+U`.

I did not seriously made the tests, as I am already late in submission, but here's the summary of the unit test I did:
|Component|Testing methodology  |
|--|--|
| Models | Fake |
| Api Client | Mock |
| Service / Repository | Mock |
| View Model | Mock |
| View Controller | views are sut, depencies are mocks |


