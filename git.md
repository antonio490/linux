
## GIT Commands

Initialize a new Git repository in the current directory
```js
git init
```

Copies a remote repository into your local machine
```js
git clone {repository}
```

Adds file changes to the staging area, ready for commit.
```js
git add {file(s)}
```

Commits the staged changes to the repository with a descriptive message
```js
git commit -m "message"
```

Uploads local commits to a remote repository
```js
git push
```

Fetches and merges changes from a remote repository to your local repository
```js
git pull
```

Lists all branches into the repository
```js
git branch
```

Creates a new branch
```js
git branch {branch name}
```

Switches to a different branch
```js
git checkout {branch name}
```

Merges changes from one branch into the current branch
```js
git merge {branch name}
```

Shows the current status of your repository and any pending changes
```js
git status
```

Displays a log of commits, including commit messages and details.
```js
git log
```

Lists the remote repositories associated with your local repository
```js
git remote -v
```

Adds a new remote repository
```js
git remote add {name}{url}
```

Removes a remote repository
```js
git remote remove {name}
```

Removes file(s) from the working directory and the repository
```js
git rm {file(s)}
```

Temporarily saves changes that are not ready for a commit
```js
git stash
```

Applies the changes made in a specific commit to the current branch
```js
git cherry-pick {commit}
```

Undoes commits by moving the branch pointer to a previous commit
```js
git reset
```

Shows the differences between the working directory and the staging area
```js
git diff
```
