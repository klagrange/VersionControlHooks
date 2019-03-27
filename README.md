# Git Hooks Pilot Project

Pilot project that uses git hooks, server side version control configurations (pull requests etc) and the JIRA api to help enforce a version control strategy. 

Rules:
- Cannot push to master or dev.
- Can only push code to master or dev via pull requests.
- Can only branch off dev.
- Can only create branch names based on created JIRA ticket.