---
title: "Should you use Github-Flow for app development?"
date: 2022-04-13
slug: should-you-use-github-flow-for-app-development
---


While working in a new project, the team wants to use github-flow
instead of any other git workflow system.

## What is Github-Flow?

Read the details in [this
blogpost](https://lucamezzalira.com/2014/03/10/git-flow-vs-github-flow/)

- Anything in the master branch is deployable
- To work on something new, create a descriptively named branch off of
  master (ie:new-oauth2-scopes)
- Commit to that branch locally and regularly push your work to the same
  named branch on the server
- When you need feedback or help, or you think the branch is ready for
  merging, open a pull request
- After someone else has reviewed and signed off on the feature, you can
  merge it into master
- Once it is merged and pushed to ‘master’, you can and should deploy
  immediately

Key is here: Everything in master is deployable and should be deployed
but what does that mean as an app developer?

In todays dev teams, scrum or kanban is daily business. Release cycles
of 1 to 3 weeks is normal.

if we now create a new release as soon as we push to the main branch,
even several times a day, we would have to push several new releases to
the app stores.

From an app customer perspective, this means updating the app several
times a day. Normally this is not a problem, as not everyone goes
through the new updates in the app stores, but I have the following
experience from my time at Doodle:

We had weekly sprints with one release at the end. So one release per
week and actually customers complained why the app updated so often.
Sometimes there were also bad reviews so I think even one app release
per day would be too much. For a website as well as the web-frontend it
is not a problem as customers always use the latest website version
anyway but for an app not so good.

I think the Github-Flow is good and simple because it makes sense but
not every merge to the main branch should be connected with a public
release.

Weekly releases at the beginning or in the middle of the week are
sufficient in my opinion.

(Header image
[credits](https://lucamezzalira.com/2014/03/10/git-flow-vs-github-flow/))
