# quizlet_action

This is a practice of software engineering.

## Requirements

- I copy words to a new file with arbitary name every day in input folder.
  - detect new file by created date.

## TODO

- [ ] push volcabulary and definitions to quizlet
- [ ] build CI/CD
- [ ] write design docs including the lifecycle

## Features

- send warning email if push failed
- detect latest file and change the name of the file to last modified date(allow duplicate with suffix number)
  - git status -uall | grep input | awk '{ print $1 }' | tr -d '[:blank:]'
  - 
- change filename to today's date
- validate input
  - at least two columns
- formatted input file
  - trim left side and right side
  - split by blank
  - join first element and rest elements by tab
- push output to quizlet
  - get cookies
  - get cs-token

## Unit Test

- consecutive tabs and spaces
- empty file
- incomplete line

## Logging

- error message

## Future TODO

- [ ] AI/ML to recommend definitions for the vocalbulary
