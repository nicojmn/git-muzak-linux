# git-muzak
> Background music for your git commits

Inserts the currently playing track in your git commit messages.

This is done in the "prepared" message, so you can still edit it in your $EDITOR if you decide the track is too awesome or something.

![git-music-ss2](https://cloud.githubusercontent.com/assets/40650/22171332/3c3ce1f2-df59-11e6-8215-aa20c4570560.png)

If you are doing a quick commit message e.g. with `-m`, things will still work:

![git-music-results-github-app-ss](https://cloud.githubusercontent.com/assets/40650/22171382/a0c1ca4c-df5a-11e6-8b83-835cafaf9602.png)


## Installation

### Prerequisites

You need to have `git` (obviously) and `playerctl` installed. The latter is a command-line utility for controlling media players that implement the MPRIS D-Bus interface specification.

You can install it via your favourite package manager, e.g.:

```
yay -S playerctl
```
On Arch Linux based systems.

```
sudo apt-get install playerctl
```
On Debian based systems.

### Cloning the repository

Clone this repository and copy the `git-muzak.sh` script to somewhere in your `$PATH`, with your desired name, e.g.:

    cp git-muzak.sh /usr/local/bin/git-muzak
    chmod +x /usr/local/bin/git-muzak

For simplicity, this is exactly what is done for you via `make install`.

## Usage

To enable for a git repository, once you are somewhere inside its directory, simply do `git muzak --install`.

    $ git muzak --install
    √♬  Linked .git/hooks/prepare-commit-msg to /usr/local/bin/git-muzak

Behind the scenes, this will symlink the script as the `prepare-commit-msg` git hook.
