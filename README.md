# code-snippets

Useful stuff (mostly). :neckbeard:

Note: this repo is left intentionally rough around (all) the edges, I'm making it public just for fun. Laugh if you want just don't blame me if you accidentally destroy something with any of these commands. :heart: :shipit:

## Some things I learned about...

* [Bourne-Again SHell (bash)][3]:bangbang:
* [Git][7]
* [Docker][2]
* [Postgres][8]
* [Domain Name Servers][4]
* [Python][5]
* [NetCDF4][6]

## Make life easier:
  1. Play in a sandbox.
  - Virtualize, break, iterate
  - This is highly generalized information
  - Tools exist that take away a lot of the pain/negatives associated with each technology
  - Knowing how and when to use specific technologies, and the best tools for the job, is something that comes with Paying Your Dues™ as a developer
  - When in doubt, make things _less_ complex so you can move forward
  - Isolate problems, freeze environments (or just certain layers of the environment)
  - Containers: when you need infantry
    - managed using tools like Docker, Kubernetes
    - lightweight, works in layers
    - fast, start and stop services quickly
  - Virtual Machines: when you need a tank
    - managed using tools like VMware :money_with_wings:, VirtualBox, Vagrant
    - slow, bulletproof (isolation)
    - heavy, requires dedicated resources (compute, storage, RAM) which makes it more robust
  2. When you find a way to do something, stash it somewhere that can be recalled and move on.
  3. Dependency management will consume you if you let it.
  4. Get really really good on a terminal; bonus points if you use [zsh][1]!



[0]: References
[1]: https://github.com/adaube/code-snippets/blob/master/oh-my-zsh.sh
[2]: https://github.com/adaube/code-snippets/blob/master/Dockerfile
[3]: https://github.com/adaube/code-snippets/blob/master/bash_snippets.sh
[4]: https://github.com/adaube/code-snippets/blob/master/fix_avahi_dot_local.md
[5]: https://github.com/adaube/code-snippets/blob/master/pandas-snippets.py
[6]: https://github.com/adaube/code-snippets/blob/master/create-netcd4.py
[7]: https://github.com/adaube/code-snippets/blob/master/git-diff-tricks
[8]: https://github.com/adaube/code-snippets/blob/master/postgres-docker.md
