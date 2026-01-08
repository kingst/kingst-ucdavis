# Stopwatch iOS app

Your tasks with creating a stopwatch app, which works nearly
identically to an iOS stopwatch app. Key features include starting and
stopping the timer, resetting it, and keeping track of laps as a timer
is running.

## Architecture

Architecturally, we have two main components: a MainView and a
StopwatchModel. We're following a basic MVVM architecture but
combining our view model and model into a single StopwatchModel.

We are using SwiftUI for our user interface and the iOS Testing
framework for unit tests. As such, we will use ObservableObjects to
communicate from the model to the view, and explicit function calls on
the model to enable the view to update states in the model in response
to UI events.

## Rules

- Don't commit any code using `git`. I'd like to inspect code you
  write before committing it.

- Don't push any code to GitHub. I'll handle pull request creation,
  etc, manually.

- Don't modify iOS project files. These are extremely tricky to get
  right, so I'll add any files you need manually.

- I will be making changes to the code periodically, so from one
  prompt to the next code may have changed. Please re-read any files
  you use to get their current state and don't assume that they are
  unchanged since your last modifications.

- Ask questions if something is unclear! I'm here to help so if my
  instructions are too ambiguous or unclear, let me know and I can
  elaborate.