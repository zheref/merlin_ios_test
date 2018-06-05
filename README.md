# Merlin Technical Test - iOS Team


![merlin](https://user-images.githubusercontent.com/36903172/40690518-1d96ca26-636d-11e8-96da-1099959227a2.jpeg)

# Our problem

This test consists of an already built application that downloads information from Reddit that contains images and text but that is malfunctioning (The Xcode Project comes next to this document and is called Prueba_iOS). 

# My solution

## Stability
Since the project was malfunctioning, several bad configurations were fixed such as wrong platform specified on build settings, missing platform definition on Podfile and others.

Also some regular and many potential crashes were addressed, including regular use of forced unwrapping of optionals, avoiding retain cycles by using weak references and capture lists into closures. Also dispatching back to the main thread when trying to interact with the UI from a background thread.

## Target
The app was fixed in order to target iOS only and it was made Universal by also taking advantage of Autolayout in order to support multiple screen sizes by using only one storyboard capable to resize and reaccomodate accordingly.

## Practices
More accurate names for classes were introduced, such us from "App" to "FeedItem" (considering this is the actual information the app is fetching from Reddit) and other such us methods comforming more accurately to the Swift Design Guidelines.

The code was completely refactored in order to get closer to a "good practices" approach by separating the different responsibilities and micro tasks into different new methods within the already existing classes or by introducing a new class responsible of this isolated task (as an example: FeedItemParser).

Also a new class was introduced called "Constants", responsible of holding most of the literals so that it can be avoided to use this latest ones, making the codebase more centralized and secure. Also in this Constants file, other global symbols were declared for facility purposes such us the NetworkCallback which is an alias of a regularly used dictionary combination ([String: Any?]).

A lot of semicolons were removed, bad code formatting, lack of use of conditional unwrapping through ifs and guard, wrong vocabulary that was not matching regular iOS's verbosity, and so on along with a bunch of changes to follow better practices.

Finally the code was migrated completely into Swift 4 dealing with all the warnings coming from this transition.

## Architecture

Several different archictectures were used such as the implementation of different stereotypes such as Singletons, Factories, Fetchers, Parsers and DataStores, with the sole intention of separating correctly responsibilities; as well as a very Protocol Oriented Programming approach.

The architectural design pattern was kept as MVC, since given the low complexity and extent of this app, a more advanced pattern such as MVP, MVVM or VIPER would be totally misused and would add unnecessary complexity to the codebase making harder its sustainment flow.

## Error Handling

New error enumerations were introduced in order to deal with not ideal situations. Also an extension of UIViewController was written to easily present an error alert with the localized description of any unexpected error.

## UI

The new modern "Large Title" style was introduced in order to make the app look more professional and matching the latest design proposal introduced by Apple in iOS 11, as well as some other design changes like improved space management and a more balanced usage of color to make the app easier to stare at for extended periods of time.

Since the content brought from Reddit as description was formatted as Markdown, a new parser was introduced to show this content rendered directly with its corresponding rich format.

The Feed Item thumbnails were applied a corner radius to make them look as a circle as a design touch.

## UX

Since the app was already using a classical Navigation Controller approach for its UX, not too much was introduced regarding this, since this by itself comforms to the iOS Human Design Guidelines. A couple of scaling animations for images were introduced also to make it look cooler.

No "feedback" was introduced since this is already presented enough by the already implemented UIKit's UINavigationController for the features the app is serving.

## FAQ
To the reviewer of this document and test, some points to consider:

I tried to be very specific in the explanation of this resolution's approach. However if further information about a topic is required, I will be pleased to provide an extended explanation.

It's important to clarify that some practices were implemented solely in an specific point in order to show my expertise on that.

I hope you like it and feel free to reach back out.

Peace!



