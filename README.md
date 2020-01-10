#  Dott Coding Challenge

- The architecture used is MVVM, aided with heavy usage of Combine.
- The networking layer is structured and can be explained with 3 structures to make an API call:
    - Client
    - Request
    - Response
    
    Client executes a request you create, and returns a decoded type-safe response.
    
- I have written some very very basic tests, but there can be many more written considering the structure of the app. All the views, view models, and models are  dependency-injectable.


## Requirements

There are no dependencies, so all you need to run the app is the latest version of Xcode.

## Notes

- The app should show restaurants around your current location if you have granted it permission to use you location. If you haven't you can still pan to any area and check the restaurants in that area.
- To get details of a restaurant tap on the placemark, and tap on the "i" button (disclosure button) to segue to the details.


