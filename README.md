Just One Single History
=======================

The Josh project is aimed at supporting trunk based development in a Git monorepo.

Proxy
-----

The main component of Josh is the `josh-proxy` which enables on the fly virtualisation
of Git repositories hosted on an upsteam Git host.

On the most basic level this can be used to support partial cloning for Git repositories.

Lets say you want to clone just the *Documentation* subdirectory of Git itself:

```
josh-proxy --local=/tmp/josh --remote=https://github.com& --port=8000
git clone http://localhost:8000/git/git.git:/Documentation.git
```

This will give you a repository containing just the *Documentation* part of the upstream
git tree including it's history.

Josh supports read and write access to the repository, so when making changes
to any files in the virtualised repository you can just commit and push them
like you are used to.

Prefix
------

Another useful transformation that `josh-proxy` can do is moving a whole history into
a subdirectory.
This is essentially what has been described as the *git subtree* approach to integrating
code from multiple repositories.
This makes it very easy to compose a new project out of several existing repositories:

```
git init
git commit -m "initial" --allow-empty
git fetch http://localhost:8000/bla/bla.git:prefix=dependencies/bla.git master:bla
git merge bla --allow-unrelated

git fetch http://localhost:8000/bla/foo.git:prefix=dependencies/foo.git master:foo
git merge foo --allow-unrelated
```

One obvious use case for this feature is to help when switching a project or organization
from a manyrepo setup to a monorepo.
