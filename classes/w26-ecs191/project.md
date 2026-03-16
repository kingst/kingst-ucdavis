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

### Google App Engine requirements

For your server portion of the project, you are required to use a
Google App Engine Python project. Within this project you **must**
use:

- Google App Engine's Standard Environment with Python 3.10 - 3.13 runtime

- A `.gcloudignore` file to omit extra files from your server (like
  your `venv` directory)

- For storing data you must use `Firestore in Datastore Mode`. The
  python package for this is: `google-cloud-datastore`

- Google Cloud Storage buckets to store images or big files if needed

- Flask web service, Blueprint for decomposed API handling

- Your repo should have api/, services/, and models.py organization
  for your API handlers, services and data models

- For an example to help get you started, you can use the "SMS
  authentication"
  [example](https://github.com/kingst/ecs191-authentication)

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

#### Milestone 1: One AI feature + customer discovery

Milestone 1 is about getting the beginnings of your app working. You
should have several views working and integrated with the server to do
whatever you need them to do. Focus on the feature that adds value to
people rather than the types of features that any app would have, like
a login page.

For this milestone, you need to have something AI related integrated
into your app and be ready to demonstrate it at our meeting.

At this milestone, you should also have talked to 10 potential users
of your app to learn about what problems they have that you might be
able to solve.

In your discovery conversations you aren't trying to get people to use
your product -- you are simply trying to understand the problems that
they have. Also, ask people about past experiences, not speculation on
the future. Here is an example script that you can use to get started
on your discovery interviews:

  - Tell me about the last time you <fill in>

  - What was hard about that?

  - Why was it hard?

  - How do you solve that now?

  - Why is that solution not good enough?

**Requirement:** Each group member is required to conduct at least one
of the 10 interviews. It's fine to have multiple members at interviews
(and in fact helps for note taking) but each member needs to lead at
least one of them.

**What to turn in:**

- A link to your github repo that includes all of the documents +
  source code that you have thus far, including `discovery_summary.md`
  and `discovery_details.md`.

- A `discovery_summary.md` file that concisely summarizes what you
  learned from your 10 discovery conversations. The emphasis here is
  on problems you discover, but include some early ideas on ways that
  your product might help with these problems. How has your thinking
  changed after conducting these interviews?

- A `discovery_details.md` file that shows the raw notes from your
  conversations. _Hint:_ Take notes as you talk to people and this
  requirement should be easy.

**Important:** For the two discovery docs, make sure that these are
_not_ written by an LLM. You can use an LLM to clean up grammar, make
it more concise, etc, but I want you to _think_ about the sythesis of
these conversations yourself and talk about it as a group, don't just
rely on ChatGPT to tell you what you learned. Human insight here is
key.

**When we meet:**

- Have a two sentence description of your app.

- Be ready to show us your app working either on a simulator or a
  real device.

- Have 2-3 high priority questions that you want to ask the course staff

- Demonstrate your AI feature and your "magic moment" (these can be
  the same for some apps).

- Be ready to talk about what you learned from talking to potential
  users.

#### Milestone 2: Main feature working, testing the new user experience

In this milestone, you will have your main feature working and test
out how effectively people can go from being new users to experiencing
the main benefit of your product (your magic moment).

You need to have at least 9 user interviews for this milestone. These
interviews are broken down into (1) initial testing with three users,
(2) iterating based on what you learn and testing on three users, (3)
repeat the iterating and testing cycle on three users. The three users
need to be different humans and there are three distinct rounds of
testing + iteration, so 9 unique humans total.

For your user interviews, use the script that we introduce in the
"Product engineering" lecture. At a high level, the experiment
consists of having people complete a task using your app. This
represents a shift from "tell me" to "show me" as we engage with
people who use your app. The five phases of the exeriment are:

  - Phase 1: The Setup (lower the stakes)
  - Phase 2: The "First Glance" (The 5-Second Test)
  - Phase 3: The Task (The Core Loop)
  - Phase 4: The AI "Vibe Check"
  - Phase 5: The Debrief

For more details and examples of this flow, see the "Product
engineering" lecture.

To help you get practice with user interviews, we will provide time in
class for you to test out your new user experience on your classmates
and the course staff will provide feedback on your interviews.

**What to turn in:**

- A link to your github repo that includes all of the documents +
  source code that you have thus far, including `new_user_summary.md`
  and `new_user_details.md`.

- A `new_user_summary.md` file that concisely summarizes what you
  learned from people using your app and what you changed with each
  iteration.

- A `new_user_details.md` file that shows the raw notes from your
  conversations. _Hint:_ Take notes as you talk to people and this
  requirement should be easy.

**When we meet:**

- Have a two sentence description of your app.

- Be ready to show us your full app working either on a simulator or a
  real device.

- Have 2-3 high priority questions that you want to ask the course staff

- Be ready to talk about what you learned from people using
  your app _and_ what you changed as a result.

#### Milestone 3: App done, tested on 10 users, feedback collected

By this milestone, you will have completed your app, convinced 10
people to use it, and collected feedback from all of them. For many
groups, Milestone 3 will be the end of the technical work for your
project this quarter. For other groups, Milestone 3 represents a last
opportunity to get feedback from the course staff whlie you still have
time to adjust before the final project is due during finals week.

In addition to getting 10 people to use your app, you will conduct
post-usage interviews with all of them to see if your app is solving
real pain for them. For your post-usage interviews, see the content
from the "qualitative user feedback" lecture for more details. At a
high level, your goal is to learn about your user's:

 - Pain

 - Promise

 - Anxiety

 - Intertia

In your interview, your goal is to learn as much as you can about
these properties of the people using your product and assess how well
your product is solving their fundamental problem.

**What to turn in:**

- A link to your github repo that includes all of the documents +
  source code that you have thus far, including `user_experience_summary.md`
  and `user_experience_details.md`.

- A `user_experience_summary.md` file that concisely summarizes what
  you learned from people using your app both in terms of quantitative
  metrics and qualitative interviews.

- A `user_experience_details.md` file that shows the raw notes from
  your conversations and detailed quantitative metrics from your
  app. _Hint:_ Take notes as you talk to people and this requirement
  should be easy.

- **Important:** You need to make sure that both Jun and Sam have your
    app installed and can use it along with the rest of your
    users. Failure to do so will result in a significant loss of
    points.

**When we meet:**

- Have a two sentence description of your app.

- Be ready to show us your full app working either on a simulator or a
  real device.

- Have 2-3 high priority questions that you want to ask the course staff

- Be ready to talk about what you learned from people using
  your app _and_ what you changed as a result.

  - You need to understand if your app is actually solving a problem
    for people. Whether it is or not doesn't matter, but the fact that
    you know the answer does.

  - **Minimum:** You should have had at least one person use your app
      and collected feedback from them.

  - **Expected:** You should have had at least 10 people use your app,
      collected feedback from them, and iterated on the feedback.

  - **Above and beyond:** Everything from Expected and for at least
      two of your users you are solving a real problem for them, and
      they are enthusiastic about your app.

## Final Project & Presentation Guidelines

The goal of this final milestone is to prove that you can not only build functional software, but that you can build a **product that solves a real problem for real users**. Your grade is split into two parts: the actual product you built (The Final Project) and how well you pitch and demonstrate it (The Demo).

You can find the rubric we will use to grade your project and presentation [here](https://docs.google.com/spreadsheets/d/1qRXb72nMy6yJS2WJphZ3fp3cTF3Plsl20vTqc2LRUnE/edit?usp=sharing) and you can get some hints about your presentation and demo from the "Pitching and demos" lecture on 3/10.

### Part 1: The Final Project (The Artifact)
Your final codebase and application will be evaluated on how well it executes its core value proposition. We are looking for quality, reliability, and user-centric design over a massive list of half-finished features. 

Your product must excel in these four areas:

* **Problem / Solution Fit & Iteration:** Does your product actually solve the problem you set out to solve? More importantly, did you build this in a vacuum? **To get full points here, you must prove that you put your product in front of real users, collected feedback, and actively iterated on your app based on what they told you.**
* **Execution & Reliability:** Your app needs to be robust. All core flows should work flawlessly. We will be looking at how gracefully you handle edge cases (like missing data or empty states). Apps that crash during normal use or consist mostly of non-functional mockups will be heavily penalized.
* **The "Core Loop":** Focus your energy on the primary action your user takes. Feature creep is your enemy. Your "core loop" should be so polished, clear, and intuitive that a new user does not need a tutorial to understand the value of your app. 
* **UX & Flow:** We are looking for a frictionless user experience. Navigation should make sense, call-to-action buttons should be obvious, and the UI should be actively helpful. If a user needs to read a manual to figure out how to use your product, your UX needs work.

### Part 2: The Final Presentation / Demo (The Pitch)
Building a great product is only half the battle; you also have to communicate its value. Your final demo should feel like a professional product pitch. Do not just read off a script—practice your timing and flow. 

Your presentation will be graded on:

* **The Explanation:** Start strong. Give a crystal-clear, concise explanation of the exact problem you are solving and how your product fixes it. Do not wing this; practice your pitch!
* **The "Magic Moment":** Every great product has an "aha!" moment. We want to see yours. To score maximum points, your demo needs a highlight that is genuinely surprising, delightful, and leverages some advanced technology to make it happen. 
* **A Smooth Flow:** Your live demo should follow a logical sequence of steps. Don't jump randomly between screens. Show us a realistic user journey through an interface that looks and feels like a real, market-ready app.
* **User Feedback & Traction:** Dedicate part of your presentation to the "human side." Articulate a strong summary of the user feedback you gathered during development. What did you learn? What conclusions did you draw, and how did that reality check shape the final product you are showing us today?

Details on your presentations:
* Don't show your entire app! Just focus on the parts that are most interesting.
* Not all group members need to speak during your presentation, I leave it up to you to determine how to provide the most compelling presentation.
* Presentations are 5 minutes long with 2 minutes for Q&A after.

### Participation

You must show up to our presentations on time and be present for all
presentations. Failure to do so will result in losing points on your
participation grade.