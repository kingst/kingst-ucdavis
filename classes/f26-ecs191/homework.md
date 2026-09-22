# Homework

During this quarter we are going to have 2 individual homework
assignments where you get experience with AI programming tools and
come up with app ideas.
- [Homework 1](add a link to it from this page)
- [Homework 2](add a link to it from this page)

Although each student is responsible for turning in their own
homework, we strongly encourage students to work together. Everyone
has to come up with their own solution, but we want people to talk
about concepts together and help each other out when stuck.

We will use Canvas to submit homework assingments this quarter.

# ECS 191: Homework 1 -- Unix Utilities with AI-Assisted Development

## Overview

In this assignment, you'll use **Claude Code** (an AI-powered coding
assistant) to build simplified versions of common Unix utilities, then
extend one of them with a new feature. This assignment introduces you
to AI-assisted development.

**What you'll build:**
- Four Unix utilities: `wcat`, `wgrep`, `wzip`, and `wunzip`
- A line numbering feature (`-n` flag) for `wcat`
- Test cases for your new feature

**What you'll submit:**
- Your specification for the `-n` feature that you use as an input to Claude Code
- `wcat.cpp` (with the `-n` flag implemented)
- Appropriate test files for your feature
- A brief reflection (see below)

**Prerequisites:**
- Download the repo to your machine from [ECS 150 Projects on GitHub](https://github.com/kingst/ecs150-projects) and read the [README for Project 1](https://github.com/kingst/ecs150-projects/tree/main/project1)

```bash
$ git clone https://github.com/kingst/ecs150-projects.git
```

## Part 1: Build the Base Utilities

### Your Task
Use Claude Code to implement all four utilities from the ECS 150 Project 1 specification:
- `wcat.cpp` - concatenate and print files
- `wgrep.cpp` - search for patterns in files  
- `wzip.cpp` - compress files using run-length encoding
- `wunzip.cpp` - decompress files

### Requirements
- All utilities must use `open()`, `read()`, `write()`, and `close()` for I/O
- Code must compile with `g++ -g -o <program> <program>.cpp -Wall -Werror`
- All utilities must pass the ECS 150 test cases (available in the repo)

### Using Claude Code

Claude Code is a terminal-based AI coding assistant. The README.md we
provide plus the test cases should be enough for Claude Code to
complete project 1. Provide a prompt to let Claude Code know about the
spec and how to run the test cases and have it solve each of the
utilities one-by-on.

## Part 2: Add Line Numbering to wcat

### Feature Specification

Extend your `wcat` implementation to support an optional `-n` flag
that prepends line numbers to each line of output, matching the
behavior of standard Unix `cat -n`.

We are leaving the specification fairly sparse because having you
create a spec is part of the assignment.

### Writing Test Cases

You need to add test cases to the standard testing framework for
project 1. You should have test cases to test out the basic feature
plus any edge cases (e.g., multiple files). When in doubt, match the
behavior of Unix `cat`. _Hint:_ Claude Code can help you understand
how the test cases work and create new ones, with some guidance.

### Development Approach

1. **Write a specification:** Write a simple prompt that explains the feature. You'll use this to get Claude Code to generate your implementation.
2. **Write your tests:** Create comprehensive test cases for the new feature
3. **Write your code:** Use Claude Code create the new feature and test it, fixing issues that arise
4. **Verify:** Ensure all original tests still pass

## Submission Requirements

Submit the following files via Gradescope:

1. **wcat.md** -- Your specification for the `-n` flag feature, used as an input to Claude Code
1. **wcat.cpp** - Your implementation with the `-n` flag
2. **test files** - Your test files (must be loadable in the standard Project 1 test suite)
3. **reflection.md** - A brief reflection (300 words max) addressing:
   - How did using Claude Code change your development process?
   - What challenges did you encounter with AI-assisted development?
   - Did you understand the code Claude Code generated? How did you verify this?
   - How did you decide what tests to write?

## Grading Criteria

- **Line numbering feature (80%):** `-n` flag works correctly
- **Code quality (10%):** Clean, readable, properly commented
- **Reflection (10%):** Thoughtful analysis of AI-assisted development

## Academic Integrity

- You are required to use Claude Code for this assignment -- no manually written code is allowed
- You must understand all code you submit
- You may discuss approaches with classmates but not share code, tests, or specifications
- Your reflection must be your own original writing

Good luck!

# ECS 191: Homework 2 -- Coming up with ideas

In homework 2, you will apply the lessons learned from lecture and
come up with ideas. You are encouraged to use LLMs to help with this
process, but it's up to you to pick your favorite ideas.

Picking ideas is always hard, so as a suggestion think about ideas
that hit all three properties: (1) solves a problem that you have
personally and you want to solve it, (2) you think solves a problem
that other college students, and (3) requires using technology that
you're interested in learning about.

One important aspect of this class is being able to explain to other
people what it is that you're building -- an elevator pitch. As a
first step, you'll need to explain to the class what you're building
in a way that makes sense.

We suggest that you use the [Y
Combinator](https://www.ycombinator.com/blog/how-to-pitch-your-company/)
guidance on how to answer the question of "What do you do?". Please
make sure to see their suggestions for how to formulate your answer
and look at the end of the blog post for guidance on improving your
answer.

The first thing I'm going to ask you in all of our face-to-face
meetings is "what does your app do?" so this exercise is good practice
for an activity that you're going to do a lot this quarter.

## Part 1 -- Elevator pitches

You will turn in 10 elevator pitches via Canvas. These elevator
pitches should be 280 characters or less and of the format:

> We [your "what" offering] for [your "who" target customer] that
> [your "why" value proposition].

Refer back to your notes from the "Innovation" lecture for more
details on how to come up with an appropriate elevator pitch.

## Part 2 -- Present the idea you want to work on to the class

You will present your favorite idea to the class by answering the
question: What does your app do? You will have one minute to present
during the lecture period to present your elevator pitch.

In class, after presenting your idea, you will have an opportunity to
find classmates to work with. You can try to recruit others to work on
your idea, or if you really like someone else's idea you can approach
them and see if it's a match.

For grading, you are graded solely on participation: As long as you
provide an answer to the question "what does your app do" you will get
full credit. You will be given a maximum of 1 minute to give your
pitch.