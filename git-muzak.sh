#!/bin/bash
set -e
debug_msg() { [[ $DEBUG = "true" ]] && >&2 echo "DEBUG: $1" ; }

show_help() {
cat << EOF
Add the currently playing track to your git commits.

Usage:
    ${0##*/} <COMMIT_MSG_FILE> <SRC_TYPE> [<HASH>] # called via hook
    ${0##*/} [--install, --remove]

Options:
    -h, --help   Display this help and exit
    --install    Install hook to current git repository and exit

(To remove from a repo later, delete .git/hooks/prepare_commit_msg)
EOF
}

##########################
### git hook functions ###
##########################

# git_dir for current directory
git_dir() {
    git rev-parse --git-dir
}

# absolute path for the bash source (e.g. this file)
bash_abs_src() {
    echo "$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)/$(basename "${BASH_SOURCE[0]}")"
}

# ACTION: symlink this script as the prepare-commit-msg hook for current git repo
install_hook() {
    local src
    local dst
    src="$(bash_abs_src)"
    dst="$(git_dir)/hooks/prepare-commit-msg"
    ln -s "$src" "$dst"
    echo "√♬  Linked $dst to $src"
}

###############################
### music related functions ###
###############################

# current track using playerctl, if active and playing
current_track() {
    playerctl metadata --format '♬ : {{ artist }} / {{ title }}' 2>/dev/null
}

##########################
### main program logic ###
##########################

# ACTION: prepare commit message. this is the actual program!
prepare_commit_msg() {
    # See https://git-scm.com/docs/githooks to see what arguments we should expect to be passed.
    # certain types of commits (based on $2) we don't want to mess with...
    # "merge" / "squash" = p. obvious
    # "commit" = surprise! this actually only applies to -c/-C/--amend commits
    if [[ $2 = "merge" || $2 = "squash" || $2 = "commit" ]]; then
        exit
    fi

    # if a song is playing, amend the prepared commit message
    SONG=$(current_track)
    if [[ $SONG ]]; then
        # If there are comment lines (starting with '#'), insert the song before them
        if grep -q "^#" "$1"; then
            awk -v song="$SONG" '{
                if (!inserted && /^#/) {
                    print "";
                    print "";
                    print song;
                    inserted=1;
                }
                print;
            }' "$1" > "$1.tmp" && mv "$1.tmp" "$1"
        else
            # Otherwise, just append after two newlines
            echo -e "$(cat "$1")\n\n$SONG" > "$1"
        fi
    fi
}

case $1 in
    -h|--help|help|"")
        show_help
        exit 1
        ;;
    --install|install)
        install_hook
        exit
        ;;
    *)
        prepare_commit_msg "$@"
        exit
        ;;
esac

