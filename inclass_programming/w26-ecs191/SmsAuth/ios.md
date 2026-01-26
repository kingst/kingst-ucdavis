# iOS SMSAuthApp

Using the API from @server/API.md we're going to create an iOS app
that demonstrates authentication using SMS.

The views:

  - EnterPhoneNumberView: where the users enters their phone number when authenticating
 
  - VerifyCodeView: Where the user enters the verification code that we send via SMS
 
  - HomeView: The view that we show for authenticated users

  - MainView: The base view that coordinates everything

The viewmodel:

  - UserService: Responsible for maintaining core User state

The model:

  - UserModel: Responsible for persisting auth tokens and accessing
    APIs to interact with the server

We will use the `PhoneNumberKit` Swift Package, which is at:

  - https://github.com/marmelroy/PhoneNumberKit

## APIs

There are issues with HTTP/3 and the iOS simulator so when we make
network connections in the app we need to disable HTTP/3 for the
simulator. We should use code that looks something like this:

```swift
    // Use ephemeral session on simulator to avoid QUIC protocol issues with App Engine
    private static let urlSession: URLSession = {
        #if targetEnvironment(simulator)
        let config = URLSessionConfiguration.ephemeral
        
        // FORCE HTTP/1.1
        // This prevents HTTP/2 and HTTP/3 upgrades entirely.
        // It is slower, but rock-solid stable for the Simulator.
        config.httpMaximumConnectionsPerHost = 1
        
        return URLSession(configuration: config)
        #else
        return URLSession.shared
        #endif
    }()
```

## ViewModel

Our core viewmodel will be a UserService observable object. This
object is where we'll keep track of the current state of the user.

Properties include:

  - isAuthenticated: true if there is an authenticated users currently

  - userState (enum): init, enterPhoneNumber, verifyCode,
    loggedIn. This state will control which view is shown from
    MainView

  - userId: the userId of the authenticated user

  - authError: a error from the server that might happen during authentication

Functions include:

  - sendVerificationCode

  - verifyCode

  - logout

  - clearAuthError

## Model

To track authenticated users, this object will use UserDefaults to
store the `token` they get from the server, and you can check if the
token is valid using an API call. You can logout by deleting the
token from memory and disk.

We will also have a separate UserModel for accessing APIs and
persisting the auth token.

## MainView

The MainView is where all of the core onboarding views are hosted,
it's the first view in the app and where we select between different
core views. The `userState` dictates which subview is shown here.

Services that all views will need and should be included in the
Environment:

  - UserService

## HomeView

A placeholder for where the authenticated experience for the app
begins

## EnterPhoneNumberView

This View will have:

  - Text: What's your phone number?
  - Text: We'll text you a code to verify your phone
  - PhoneEntry: Flag selector (US, MX, CA, India, and China only) | country code for the phone | the view where the user enters their phone number
  - Error text: Only shows when there is an authError
  - A button to advance

From a UX prespective, I have PhoneNumberKit loaded, so use it to
format the phone number as they type, ensure that it's valid client
side, and format it as an E.164 number before sending it to the
server.

Clear the error once the user edits the phone

When they press the "next" button, show a loading animation

Make sure that you mark the edit with the `telephoneNumber` type so that it will offer to autofill phone numbers.

# VerifyCodeView

This view will have

  - Text: What's the code?
  - Text: Enter the code we sent to {formattedPhoneNumber}
  - Edit: Where the user enters 6 digits
  - Error text: Only shows when there is an authError

This view should automatically advance once the user enters the code

Make sure that when iOS gives the option to autofill the one time code that it works when the user clicks on it.

Clear the error once the user edits the code or they press the `back` button