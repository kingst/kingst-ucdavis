# Homework

This quarter's homework is an individual assignment where you clone
an existing app, putting your own spin on it. The goal is to get
experience with AI programming tools, practice thinking about the
problem an app solves (rather than the features it has), and run your
first user tests before starting on your project.

This is an individual assignment: everyone needs to build and turn in
their own app. That said, we strongly encourage students to help each
other. We want people to talk about concepts together and help each
other out when stuck, but the app you submit must be your own.

We will use Canvas to submit homework assignments this quarter.

# ECS 191: Homework -- Clone an app

## Overview

In this assignment, you'll pick an existing app and build your own
version of it. Your clone should **not** be a pixel-for-pixel copy.
Instead, it should solve the same fundamental problem as the original
app, but using your own design. Keep the parts that you think work
well, change the parts that you think could be better, and give it
some of your own flair.

Picking an app you already use and like is a great place to
start. You'll have your own opinions about what it does well and what
frustrates you, and those opinions are exactly what should drive your
design.

**What you'll submit:**
- Part 1: A proposal describing the app you're cloning and your plan
- Part 2: A first cut of your app
- Part 3: Results from user testing with 5 people

## Part 1 -- Proposal

Pick the app you want to clone and write a short proposal (1 page max)
that includes:

1. **The app.** Which app are you cloning?
2. **The fundamental problem.** What is the core problem that this app
   solves for its users? Focus on the problem, not the feature
   list. For example, the problem a ride sharing app solves isn't
   "showing cars on a map," it's getting from point A to point B
   without owning a car or finding a taxi.
3. **What you'll keep.** What do you plan to do similarly to the
   original app, and why?
4. **What you'll change.** What do you plan to do differently, and
   why do you think your version will be better?

Remember that complexity is a UX bug, not a set of features. You don't
need to clone every feature of the original app. Pick the core loop
-- the one thing your app has to do really well -- and focus on
that. Everything else should be spartan.

## Part 2 -- First cut of your app

Build a working first cut of your app. It doesn't need to be polished,
but someone should be able to pick it up and use it to accomplish the
core task you described in your proposal.

Your app must be a **native mobile app**. Either iOS (written in
Swift) or Android (written in Kotlin) are fine. No Javascript, react
native, web, flutter, or other cross platform tools can be used.

We strongly encourage you to use agentic programming tools, like
Claude Code, to build your app. Speed matters here: the faster you get
something working, the sooner you can put it in front of people and
learn from them.

**What to submit:**
- A link to your source code on GitHub
- A short video (2 minutes max) demoing the core loop of your app

## Part 3 -- User testing

Get 5 people to use your app and write up what you learned. These
should be people who aren't you, and ideally people who would
actually use an app like this.

Run each session using the "Show Me" script below. The three main
rules are:

- **Shut up.** You are observing, not selling.
- **Tasks, not tours.** Don't give a tour. Give them a goal ("Book a
  flight") and observe.
- **Watch the struggle.** The exact moment they get confused is the
  exact place you need to simplify your app.

### The "Show Me" script

**Phase 1: The setup (lower the stakes).** Start with something like:

> I'm going to show you a rough prototype I'm working on. I want to be
> clear: I am testing the app, I am not testing you. If you get stuck
> or confused, that is great -- it helps me fix the design. Please be
> honest; you won't hurt my feelings.

**Phase 2: The first glance (the 5-second test).** Hand them the
device on the home screen. Do _not_ give them a task yet.

> Take a look at this screen for a few seconds. Without clicking
> anything yet... what do you think this app does?

If they say "It looks like a calendar" and you built a diet tracker,
you have failed before they even started.

**Phase 3: The task (the core loop).** Give them a scenario, not
instructions. For example:

> Imagine you are planning a trip for next weekend. Show me how you
> would use this tool to get a list of restaurants.

Silently pay attention to how they use the app. Confusion is where you
need to focus your attention.

**Phase 4: The AI "vibe check" (if your app has an AI feature).**
Test the quality of the AI response, not just the buttons.

> Look at the answer the AI just gave you. Is this useful? Do you
> trust it? What would you do with this information next?

**Phase 5: The debrief.**

> On a scale of 1 to 5, how difficult was that?
>
> If you had a magic wand, what is the one thing you would change to
> make this easier?
>
> How would you describe this app to a friend in one sentence?

### What to submit

A write-up (2 pages max) that includes:

- For each of your 5 users: their answer to the 5-second test, where
  they got stuck during the task, and their answers to the debrief
  questions
- The patterns you saw across users. Where did multiple people get
  confused?
- What you would change about your app based on what you learned

## Academic Integrity

- You must understand all code you submit
- You must write your own app. You may discuss approaches and help
  classmates when they're stuck, but you may not share code
- Your proposal and user testing write-up must be your own original
  writing, and your user testing results must come from real sessions
  with real people

Good luck!
