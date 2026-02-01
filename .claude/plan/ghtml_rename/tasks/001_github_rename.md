# Task 001: GitHub Repository Rename

## Description

**USER ACTION REQUIRED**: This task requires the user to manually rename the GitHub repository from `lustre_template_gen` to `ghtml`. This must be done before any code changes to ensure the repository URL is updated first.

## Dependencies

- None - this is the first task.

## Success Criteria

1. GitHub repository is renamed from `lustre_template_gen` to `ghtml`
2. Repository URL is now `github.com/<username>/ghtml`
3. Old URL redirects to new URL (GitHub handles this automatically)
4. Local git remote is updated to point to new URL

## Implementation Steps

### 1. Rename Repository on GitHub

1. Go to repository Settings on GitHub
2. Under "General", find "Repository name"
3. Change from `lustre_template_gen` to `ghtml`
4. Click "Rename"

### 2. Update Local Git Remote

After GitHub rename, update your local clone:

```bash
# Check current remote
git remote -v

# Update remote URL (replace <username> with your GitHub username)
git remote set-url origin git@github.com:<username>/ghtml.git

# Or if using HTTPS:
git remote set-url origin https://github.com/<username>/ghtml.git

# Verify the change
git remote -v
```

### 3. Verify Remote Works

```bash
git fetch origin
```

## Verification Checklist

- [ ] Repository renamed on GitHub
- [ ] Local remote URL updated
- [ ] `git fetch origin` succeeds
- [ ] Confirm to the agent that this task is complete

## Notes

- GitHub automatically redirects old URLs to the new repository name
- Any existing clones will continue to work until the redirect expires (or indefinitely for personal repos)
- Badge URLs in README will need updating in task 008

## Files to Modify

- None (this is a manual GitHub action)
- Local `.git/config` is updated via `git remote set-url`
