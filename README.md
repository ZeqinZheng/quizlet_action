# quizlet_action

This is a practice of software engineering.

## Requirements

- copy words to a new file with arbitary name every day in input folder.
- push the words to quizlet.

## TODO

- [x] push volcabulary and definitions to quizlet
- [x] build CI/CD

## Features

- send warning email if push failed
- detect latest file and change the name of the file to last modified date(allow duplicate with suffix number)
- formatted input file
- push output to quizlet using puppeteer daily using Github Workflow
  - concat formatted output and then output to formatted directory
  - puppeteer read the formatted file and push words to quizlet
- on failed case
  - retry using backup file on the date

## Unit Test

- TBD

## Logging

- error message

## Future TODO

- [ ] AI/ML to recommend definitions for the vocalbulary
