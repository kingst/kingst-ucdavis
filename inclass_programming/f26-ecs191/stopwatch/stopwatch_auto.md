# Stopwatch

We are making a stopwatch app that is a simplified version of the
stopwatch app that ships with iOS devices. With this app we give
people the ability to time events by starting the stopwatch and later
stopping it, displaying the duration between the two. Our app also has
the ability to keep track of laps where people can press a lap button
while the timer is running to record the duration of a lap. The sum of
the duration of all laps should equal the duration of the timer
overall.

Project at: @inclass_programming/f26-ecs191/StopwatchAuto/

You can find four screenshots of the stopwatch app at
`stopwatch_screenshots.png` There are a few extras in these screenshots
that we don't need like the tab bar at the bottom and the carousel
(two dots) in the middle of the main view, but generally this is what
I want it to look like. You should use light mode / dark mode
consistently with phone's settings.

We have xcode connected via MCP which you can use to manipulate the
project and run the simulator.

Let's break down our stopwatch app into three phases:

Phase 1: start / stop. The exit criteria for phase 1 is to have enough
of the stopwatch built so that you can start the timer, stop the
timer, and reset the timer. As the timer is running, the duration
should update in the main display.

Phase 2: lap. The exit criteria for phase 2 is to be able to track
laps while the timer is running. A few cases to get right are stopping
the timer, restarting it, and hitting lap in addition to basic lap
functionality.

Phase 3: backgrounding. The timer should continue to increment even if
the stopwatch app is backgrounded or killed by iOS. The exit criteria
is to continue to increment the duration of a running timer when the
stopwatch app is backgrounded for at least 10 seconds.

