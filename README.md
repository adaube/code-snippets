# code-snippets

A bunch of useful things that I want to reuse.

Note: this repo is left intentionally rough around (all) the edges.

Test things in a sandbox. No guarantees in life except things will break, just learn from it!


## Links
### Quick install scripts for essential dev tools
* [Java10 (Linux Mint specific)][11]

### Knowledge Base
* [Bash][3]
* [Git][7]
* [Docker][9]
* [PostgreSQL (and containerized Postgres)][8]
* [Domain Name Servers][4]
* [Python][5]
* [NetCDF4][6]
* [NAS (Synology)][10]

## Make life easier:
- This is highly generalized information
- Tools exist that take away a lot of the pain/negatives associated with each technology
- Knowing how and when to use specific technologies, and the best tools for the job, is something that comes with Paying Your Dues™ as a developer
- When in doubt, make things _less_ complex so you can move forward
1. Play in a sandbox.
  - Virtualize, break, iterate 
  - Isolate problems, freeze environments (or just certain layers of the environment)
2. When you find a way to do something, stash it somewhere that can be recalled and move on.
3. Dependency management will consume you if you let it.
4. Get really really good on a terminal; bonus points if you use [zsh][1]!

## Virtualization
1. Containers: when you need infantry
  - managed using tools like Docker, Kubernetes
  - lightweight, works in layers
  - fast, start and stop services quickly
2. Virtual Machines: when you need a tank
  - managed using tools like VMware :money_with_wings:, VirtualBox, Vagrant
  - slow, bulletproof (isolation)
  - heavy, requires dedicated resources (compute, storage, RAM) which makes it more robust
  
[0]: References
[1]: https://github.com/adaube/code-snippets/blob/master/oh-my-zsh.sh
[2]: https://github.com/adaube/code-snippets/blob/master/Dockerfile
[3]: https://github.com/adaube/code-snippets/blob/master/bash_snippets.sh
[4]: https://github.com/adaube/code-snippets/blob/master/fix_avahi_dot_local.md
[5]: https://github.com/adaube/code-snippets/blob/master/pandas-snippets.py
[6]: https://github.com/adaube/code-snippets/blob/master/create-netcd4.py
[7]: https://github.com/adaube/code-snippets/blob/master/git-diff-tricks
[8]: https://github.com/adaube/code-snippets/blob/master/postgres-docker.md
[9]: https://github.com/adaube/code-snippets/blob/master/docker.md
[10]: https://github.com/adaube/code-snippets/blob/master/nas.md
[11]: https://github.com/adaube/code-snippets/blob/master/java10-linux-mint.sh
