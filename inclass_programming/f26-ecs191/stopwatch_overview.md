# Stopwatch app

We are building a stopwatch app. This app works as a mechanism for
allowing people to measure how long events take via an app, displaying
elapsed time as it runs. It also has the ability to track individual
"laps" that make up a longer timer session.

This app is a simplified version of the iOS stopwatch app, using only
a digital time display.

The project is at: @inclass_programming/f26-ecs191/StopwatchManual/

## Architecture

Architecturally, we have two main components: a MainView and a
StopwatchModel. We're following a basic MVVM architecture but
combining our view model and model into a single StopwatchModel.

We are using SwiftUI for our user interface and the iOS Testing
framework for unit tests. As such, we will use ObservableObjects to
communicate from the model to the view, and explicit function calls on
the model to enable the view to update states in the model in response
to UI events.
