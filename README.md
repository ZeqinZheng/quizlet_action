# quizlet_action

This is a practice of software engineering.

## Requirements

- I copy words to a new file with arbitary name every day in input folder.
- push the words to quizlet.

## TODO

- [ ] push volcabulary and definitions to quizlet
- [ ] build CI/CD
- [ ] write design docs including the lifecycle

## Features

- send warning email if push failed
- detect latest file and change the name of the file to last modified date(allow duplicate with suffix number)
- formatted input file
- push output to quizlet using puppeteer daily
  - concat formatted output and then output to formatted directory
  - puppeteer read the formatted file and push words to quizlet

## Unit Test

- TBD

## Logging

- error message

## Future TODO

- [ ] AI/ML to recommend definitions for the vocalbulary
