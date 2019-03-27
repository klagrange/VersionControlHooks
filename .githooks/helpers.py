#!/usr/bin/python3
import sys
import json
import requests
from subprocess import check_output
import subprocess
import json
import re
import os

def get_current_branch():
    "returns the name of the current branch"
    return check_output(['git', 'symbolic-ref', '--short', 'HEAD']).strip().decode("utf-8")

def get_previous_branch():
    "returns name of the previous branch from which we checkout out"
    full_name = check_output(['git', 'rev-parse', '--symbolic-full-name', '@{-1}']).strip().decode("utf-8")
    return re.search("([^\/]+$)", full_name).group(1)

def go_to_previous_branch_and_delete_current_branch():
    "deletes current local branch and checkouts to where we came from (previous branch)"
    previous_branch = get_previous_branch()
    current_branch = get_current_branch()
    subprocess.call(["git", "checkout", previous_branch])
    subprocess.call(["git", "branch", "-D", current_branch])

def call_jira():
    "calls jira"
    API_ENDPOINT = "https://JJJJ.atlassian.net/rest/api/2/search"
    USERNAME = "xxx@yyy.ooo"
    PASSWORD = "XXX"
    DATA = {
        "jql": "project = HPP",
        "startAt": 0,
        "fields": ["status", "priority", "labels", "updated"]
    }
    HEADERS = {
        'Content-Type': 'application/json',
    }

    results = requests.post(url = API_ENDPOINT, auth=(USERNAME, PASSWORD), headers=HEADERS, data=json.dumps(DATA))
    results_dict = results.json()

    allowed_branches = []
    details = []
    for issue in results_dict["issues"]:
        branch = issue["key"]
        updated = issue["fields"]["updated"]
        priority = issue["fields"]["priority"]["name"]
        status = issue["fields"]["status"]["name"]
        labels = issue["fields"]["labels"]

        if status != "Done":
            allowed_branches.append(branch)
            details.append({
                "branch (issue number)": branch,
                "priority": priority,
                "last updated on": updated,
                "current status": status,
                "labels": labels
            })

    return allowed_branches, details
