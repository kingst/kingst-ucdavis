# Basics for our Stopwatch app

At a high level we have two main components: a MainView and a StopwatchModel

## MainView

- One button for start / stop, which will start the timer and stop it when it's running.

- One button for reset / lap, which will reset a stopped timer and create a new lap for a running timer when pressed

- A list of laps for this current session

- Duration in HH:MM.SS format. So in other words a duration of 1h 3m 45s will look like this: "01:03.45"

- Let's use darkmode for this app

## StopwatchModel

Location: inclass_programming/w26-ecs191/Stopwatch/Stopwatch/StopwatchModel.swift

In general, the stopwatch can be in a `running` or `stopped` mode,
where it is initialized in `stopped` mode. While it is running, the
duration stored in the StopwatchModel should update several times
per second.

The model includes a `startStopButtonPress` function that toggles the
mode between the running and stopped states. It also includes a
`lapResetButtonPress` function that will start a new lap when running
and reset the duration when stopped.

The ObservableObject that we use to communicate back with the main
view should have the following fields that are published and updated
when appropriate:

- durationHours, durationMinutes, durationSeconds to signify the current duration

- startStopButtonText to show the appropriate text when given the
  current mode ("stop" when running and "start" when stopped)

- startStopButtonColor to signify the color the button should use
  (green when stopped and red when running)

- lapResetButtonText to show the appropriate text given the current
  mode ("lap" when running and "reset" when stopped)

Note: the lapReset button can always be gray.