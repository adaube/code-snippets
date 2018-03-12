# find how big our repo has gotten
du -shc .git

# reduce repo size, attempt 1
git reflog expire --expire-unreachable=now --all
git gc --prune=now
