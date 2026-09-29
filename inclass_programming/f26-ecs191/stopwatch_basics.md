# Basic functionality for the Stopwatch app

This document outlines the basic functionality of our Stopwatch
app. We have two main components: a MainView and a StopwatchModel.

## MainView

There are four main widgets that make up the overall main view:

- A `duration` which displays time in HH:MM.SS format. For example, a
  duration of 1 hour 14 minutes 3 seconds is "01:14.03"

- A `startStopButton` that toggles the stopwatch between running and
  idle modes.

- A `lapResetButton` that will start a new lap while running or reset
  the timer when stopped.

- A `lapList` that is a list of strings that shows each lap that is
  part of the current timer session

## StopwatchModel

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

