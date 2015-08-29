# git kit

This is my git kit, a collection of shell scripts that have formed over time to help me with various repetitive git tasks on several of my git repositories.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Contents**

- [Installation](#installation)
  - [Environment](#environment)
  - [Testing](#testing)
- [Commands](#commands)
    - [`all-exec <command*>`](#all-exec-command)
    - [`kill`](#kill)
    - [`pull-request [branch [target-repo]]`](#pull-request-branch-target-repo)
    - [`purge [prefix [remote]]`](#purge-prefix-remote)
    - [`purge-remote [prefix [remote]]`](#purge-remote-prefix-remote)
    - [`retire [remote]`](#retire-remote)
    - [`sync [branch [remote]]`](#sync-branch-remote)
    - [`topic-start <topic> <name> [branch]`](#topic-start-topic-name-branch)
    - [`topic-finish [branch [remote]]`](#topic-finish-branch-remote)
    - [`wipe`](#wipe)
  - [Plumbing commands](#plumbing-commands)
    - [`current-branch [branch]`](#current-branch-branch)
    - [`remote-exists [remote [branch]]`](#remote-exists-remote-branch)
    - [`select-branch [branch [remote]]`](#select-branch-branch-remote)
    - [`select-remote [remote]`](#select-remote-remote)
- [Acknowledgements](#acknowledgements)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Installation

Installation is most easily done with [`npm`](https://www.npmjs.com/):

```bash
npm install -g git-kit
```

If you want to modify the scripts, just fork/clone the repository and then, from within the project, run:

```bash
npm link
```

This will make the commands globally available while still allowing you to adapt them and use version control.

### Environment

These scripts have for now only been tested on OSX Yosemite with bash version 3.2.57 and Git 2.4.0. I would expect them to work with a much wider version range of these tools though.

### Testing

```bash
npm test
```

No unit tests are yet in place but linting is performed by [shellcheck](http://www.shellcheck.net/). If you'd like to submit a pull request, please make sure no errors are generated.


## Commands

For many of these commands, `branch` and `remote` are optional arguments. If they are not supplied, the `select-remote` and `select-branch` commands are used to determine suitable defaults.

These scripts are mostly simple wrappers around existing git commands, and not a lot of validation is going on so handle them with as much care as you would every other shell command. They are executed with the `-eE` switches for bash though, and will abort as soon as anything unexpected happens. Also, the porcelain commands use the `-x` switch where relevant to keep you informed about their actions.

I use `<>` to indicate mandatory arguments and `[]` to indicate optional ones.

#### `all-exec <command*>`

Simple wrapper around `git for-each`. Executes a command on all submodules as well as the main repository. 
Useful in combination with `git sync` to fully update your repository or just with `git status` to get a full summary.

A handy alias I use for this is `git all` for exclusive use with git commands:

```bash
git config --global alias.all "all-exec git"
```

#### `kill`

Delete current branch local and remote, even when it's not merged into remote HEAD.

#### `pull-request [branch [target-repo]]`

Initiate a pull request from the current branch to the one specified and open the resulting url in your browser.

Requires presence of the Hub utility: https://hub.github.com/

Target-repo is interpreted Github-style: `[user/]repo` (i.e. `git-kit` or `bsander/git-kit`)

#### `purge [prefix [remote]]`

Find and delete all branches with a given prefix that have been merged in the current HEAD. Also finds and deletes these branches from the given (or default) remote

`prefix` will default to the regexp `(feature|release|hotfix)/` when not supplied. Using an empty string `""` as prefix will disable it and purge all branches that have been merged into the current HEAD.

#### `purge-remote [prefix [remote]]`

Same as `purge`, but uses a remote branch as reference. Useful when your co-workers fail to clean up after themselves.

#### `retire [remote]`

Delete a branch and replace it with a `retired/<branch-name>` tag in order to preserve history

#### `sync [branch [remote]]`

Performs a fetch, merge and fast-forward-only push for all remote branches that are locally tracked. Also performs a `purge` from the given branch afterwards. I highly recommend setting up auto rebasing to generate cleaner merges with the following command:

```bash
git config --global branch.autosetuprebase always
```

#### `topic-start <topic> <name> [branch]`

Creates a `<topic>/<name>` branch from the given branch (or current HEAD). I use different versions of this with aliases:

```bash
git config --global alias.feature-start "topic-start feature"
git config --global alias.release-start "topic-start release"
git config --global alias.hotfix-start "topic-start hotfix"
```

#### `topic-finish [branch [remote]]`

Pushes the current branch to the given remote and initiates a Github pull request to the target branch. Checks out the target branch after the pull request was created.

While the topic of the current branch doesn't matter to this script, you may still want to set up counterparts to the aliases mentioned in `topic-start`:

```bash
git config --global alias.feature-finish "topic-finish"
git config --global alias.release-finish "topic-finish"
git config --global alias.hotfix-finish "topic-finish"
```

#### `wipe`

A safer alternative to `git reset --hard`. This will commit all your changes and then rewind your HEAD back to the current state. While this essentially achieves the same effect as a hard reset, you will be able to access a hash (mentioned somewhere in the git commit output or available from `git reflog`) to prevent those immediate "*oh, fuck*" moments. Note that the savepoint commit is orphaned and may still be subject to git's garbage collection at any time.

### Plumbing commands

These commands are used under the hood in the above porcelain scripts, but may still come in handy once in a while or maybe in your own scripts.

#### `current-branch [branch]`

Without arguments, prints the name of the current branch. If an argument is supplied, this will succeed or fail based on whether the current branch is the same as the supplied argument.

#### `remote-exists [remote [branch]]`

Succeeds or fails based on whether `branch` exists on `remote`

#### `select-branch [branch [remote]]`

Outputs the named branch, the name of the `HEAD` branch of the given remote, or `master`. Will fail when such a branch does not exist locally.

You can configure a default branch for your repository with a git config command:

```bash
git config kit.default-branch develop
```

#### `select-remote [remote]`

Outputs the given remote, the default configured remote, or `origin`, or fails when such a remote does not exist.

You can configure a default remote for your repository with a git config command:

```bash
git config kit.default-remote upstream
```

## Acknowledgements

Some articles that helped me with ideas and implementations of some of these commands:

- http://haacked.com/archive/2014/07/28/github-flow-aliases/
- http://nvie.com/posts/a-successful-git-branching-model/
- http://blogs.atlassian.com/2013/05/git-automatic-merges-with-server-side-hooks-for-the-win/
