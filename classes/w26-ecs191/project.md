# Project

This quarter you will design and ship an app. The goal is for you to
get experience with modern AI tools for rapid prototyping of realistic
applications suitable for people to use. As a part of this project,
you will build a usable app, get people to use it, and learn something
about their use of your product.

Project groups should be 4-5 members. Any other group size needs
explicit approval by the professor.

## Requirements

Your project must include:

- **A native mobile app.** Either iOS (written in Swift) or Android
  (written in Kotlin) are fine. No Javascript, react native, web,
  flutter, or other cross platform tools can be used.

- **A server.** Your server will provide APIs for your app to use and
  must be written in Python and run in Google's App Engine.

- **A differentiated feature.** Your app has to do something that is
  better / different from apps today. Differentiation doesn't mean no
  one has ever done anything like it -- it means your specific
  combination of features, UX, or target users creates something
  different from what's available today.

- **An AI feature.** Your app must include at least one AI
  feature, and the interface to this feature must _not_ be chat. We
  use a broad definition of "AI" that includes ML running on your
  phone or API calls out to services that provide AI features. The AI
  feature can either be the main feature for your app, or it can be
  subtle part of it that is outside of the main value your app
  provides, but it must include one AI feature.

- **A surprising feature.** Your app needs to have one aspect about it
  that is surprising (in a good way) to your users. Sometimes we call
  this our "magic moment".

## Problem selection

We will spend time in class and provide a homework assignment to help
you think of an idea. Coming up with an idea that you are excited
about is important because this class is a lot of work, and if you're
genuinely excited about the idea then it'll make your experience in
the class much better.

We _strongly suggest_, but don't require, that you pick a problem that
college students have. This type of problem has two advantages: (1) as
college students you can think of problems you have and see if it
generalizes to other students and (2) when you need to find people to
use your app, you have access to a lot of college students, making
your job of finding users easier.

## Want an A+?

If during the quarter you get 350 daily active users, and you'll get
an A+ in the class independent of the rest of your graded
materials. Above all I love impact, so if you can show that people are
getting value from your app this quarter I will give you full credit
for the class. Note: This is the only way to get an A+ in this class.

The requirements for getting an A+ are:

- You need to have 350 daily active users by the day that the project
  is due

- Students from this class can count towards your 350 daily active
  users. In fact, I want students to help each other out by using your
  apps and giving feedback

- You can't pay people to use your app and you can't have bots act as
  "users" -- it has to be real humans

- If you want to try this, you need to have a written agreement with
  Professor King about how you define and measure daily active users

- Your app needs to be created this quarter as a part of this
  class. You can't bring in past projects that you've worked on and
  get credit

## Project details

There are two main aspects to this project: technical and user
related. From a technical perspective, we want you to demonstrate the
ability to write software quickly, making use of AI tools where
appropriate. From a user perspective, we want you to get people to use
your app and learn something from the experience. Even if you learn
that your idea doesn't solve the problem you set out to solve, that is
still learning!

### Technical artifacts

Documentation and test cases are key to getting the most out of
agentic programming tools. These are just as important as producing
reasonable source code and in fact maybe even more important because
they're how you will be able to produce reasonable source code. The
main technical artifacts are:

- Source code for your app and server hosted on GitHub.

- Some way for the staff to run your app, ideally in the app store or
  TestFlight.

- An `overview.md` file. This is a high level document that describes
  the fundamentals of your app and includes (1) what problem are you
  solving and why is it important, (2) how have others solved this
  problem and what is wrong with these solutions, (3) what is
  different about your solution and why does it solve the problem, and
  (4) what are the key measures of success for your app (or in other
  words, how will you know that it actually solves the problem).

- A `client_architecture.md` and `server_architecture.md` file that
  explain your high level architecture. These architecture documents
  should explain the main components of your client or server (the
  most important 5-10 modules), the key data structures, and the main
  interfaces within your application.

- An `API.md` file that defines the APIs that you will expose from
  your server for your client to call.

- Test cases and scripts to run your test cases from the command
  line. These are critical because agentic programming tools will use
  these to know if their implementation is correct and fix any
  mistakes that it makes. Having scripts to run test cases from the
  command line enables your AI tools to run test cases automatically
  as it implements features. _Hint:_ Agentic programming tools are
  _very good_ at creating test cases automatically, just make sure
  that you check them by hand to confirm that they're testing what
  they should be testing.

- Specs for all features. For each feature that you implement, make
  sure to pick something relatively small in size. Examples include a
  single API handler in your server or a single view + associated
  logic in your client. With this scope of feature, write a detailed
  document (e.g., `myfeature.md`) to explain to the AI tools what you
  want it to implement. This description tends to be fairly detailed
  and includes (1) A description of the feature, (2) an explanation
  of how it fits within the architecture of your app and for the
  subcomponents of your feature (3) key data structures and functions,
  and (4) a description of each of the features and data structures
  you outline. From this, plus test cases, agentic programming tools
  should be able to provide a reasonable implementation.

### User artifacts

To measure if your app is solving the problem you set out to solve,
you need to have both simple quantitative metrics and qualitative data
from talking to the people who use your app. The details of these will
be highly specific to each app and will be something that the course
staff will work with you to develop over the quarter.

### Milestones

To help provide you with feedback and guidance, we decomposed the
project into a number of different milestones throughout the
quarter. These milestones help you ensure that you're making steady
progress on your project and give the staff an opportunity to let you
know what's going well and your areas of improvement.

#### Project proposal

The project proposal is simple: an elevator pitch for your app, a list
of group members, and a name for your group. This milestone serves as
a forcing function to get you to form a team and to have an initial
idea of what you're going to work on.

**What to turn in:**

- A `proposal.md` file that includes the information from your
  proposal.

#### Milestone 0: One app view + API call

Milestone 0 is all about getting the basics in place to start
implementing your app. It includes having a first cut of all of your
`overview.md`, `client_architecture.md`, `server_architecture.md`, and
`API.md` files. It also includes one feature (`somefeature.md`), test
cases, and a demonstration of your app talking to your server.

Your architecture and API files do not need to be complete as these
will evolve as you make progress on your app, but you should have
these for at least the parts of your app you are working on at this
point.

**What to turn in:**

- A link to your github repo that includes all of the documents +
  source code that you have thus far.

  - All group members need to contribute code

  - The code you demo needs to be on your `main` branch, fully
    integrated, in github

**When we meet:**

- Be ready to show us your app working either on a simulator or a real
  device.

  - **Minimum:** Have one feature working, client/server communication

  - **Expected:** A version of your app working, but without any polish

- Have a two sentence description of your app.

- Have 2-3 high priority questions that you want to ask the course staff

#### Milestone 1: One AI feature

Milestone 1 is about getting the beginnings of your app working. You
should have several views working and integrated with the server to do
whatever you need them to do. Focus on the feature that adds value to
people rather than the types of features that any app would have, like
a login page.

For this milestone, you need to have something AI related integrated
into your app and be ready to demonstrate it at our meeting.

At this milestone, you should also have talked to 10 potential users
of your app to learn about what they might want.

**What to turn in:**

- A link to your github repo that includes all of the documents +
  source code that you have thus far, including `discovery_summary.md`
  and `discovery_details.md`.

- A `discovery_summary.md` file that concisely summarizes what you
  learned from your 10 discovery conversations.

- A `discovery_details.md` file that shows the raw notes from your
  conversations. _Hint:_ Take notes as you talk to people and this
  requirement should be easy.

**Important:** For the two discovery docs, make sure that these are
_not_ written by an LLM. You can use an LLM to clean up grammar, make
it more concise, etc, but I want you to _think_ about the sythesis of
these conversations yourself, don't just rely on ChatGPT to tell you
what you learned. Human insight here is key.

**When we meet:**

- Have a two sentence description of your app.

- Be ready to show us your app working either on a simulator or a
  real device.

- Have 2-3 high priority questions that you want to ask the course staff

- Demonstrate your AI feature and your "magic moment" (these can be
  the same for some apps).

- Be ready to talk about what you learned from talking to potential
  users.

#### Milestone 2: Main feature working, classmates use your app

In this milestone, you will have your main feature working and swap
apps with a different group in the class. In other words, you use
their app and they use your app and you provide each other with
feedback.

Fundamentally, you have to have enough of your app working so that you
can test out how well it solves the problem you're working on for
these people. Since classmates will be using it, your app can have
some rough edges as they will be understanding.

**What to turn in:**

- A link to your github repo that includes all of the documents +
  source code that you have thus far, including `classmate_summary.md`
  and `classmate_details.md`.

- A `classmate_summary.md` file that concisely summarizes what you
  learned from your classmates using your app

- A `classmate_details.md` file that shows the raw notes from your
  conversations. _Hint:_ Take notes as you talk to people and this
  requirement should be easy.

**When we meet:**

- Have a two sentence description of your app.

- Be ready to show us your full app working either on a simulator or a
  real device.

- Have 2-3 high priority questions that you want to ask the course staff

- Be ready to talk about what you learned from your classmates using
  your app _and_ what you thought of their app.

#### Final project

At the end of the quarter, you will submit your final project. This
project will include all documentation from the quarter, updated to
reflect the final state of your app, and some way for the staff to
test out your app (TestFlight link, build instructions, App store
link, etc.). Your instructions need to be clear so that we can run and
test your app.

In this final phase, you will get 5 people from outside of the class
to use your app and give you feedback. Learning something from this
feedback is the goal, even if the feedback is negative. Having an app
that people are unable to use due to bugs or difficult UI/UX will
result in a significant loss in points. Having a smooth experience
that people hate will make you eligible for full credit.

**What to turn in:**

- A link to your github repo that includes all of the documents +
  source code for your final project.

- Instructions on how to run and test your app.

- A `final_summary.md` document that summarizes what you learned from
  having 5 people use your app.

- A `final_details.md` document that outlines the raw feedback from
  your users that you use as the basis for your synthesis.

#### Pitch and demo

During the final timeslot, you will give a pitch for your app and
demonstrate what you have so far. The details for what we're expecting
here will be convered in dedicated lectures during the quarter, please
see the slides/vidoes from these classes for more information.
