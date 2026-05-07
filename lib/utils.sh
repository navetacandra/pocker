#!/bin/bash

# Colors and formatting
R='\033[0;31m'; G='\033[0;32m'; Y='\033[1;33m'; B='\033[0;34m'; C='\033[0;36m'; NC='\033[0m'; BOLD='\033[1m'; NL='\r\033[K'

# Error handler
error() {
    echo -e "${R}[ERR]${NC}  $1"
    exit 1
}

# Get current directory of the script
get_cwd() {
    local source="${BASH_SOURCE[1]}"
    while [ -L "$source" ]; do
        local target="$(readlink "$source")"
        if [[ $target == /* ]]; then
            source="$target"
        else
            local dir="$(dirname "$source")"
            source="$dir/$target"
        fi
    done
    dirname "$source"
}

# Resolve image name to REPO:TAG format
resolve_image_name() {
    local raw_image="$1"
    local repo_tag
    local repo
    local tag

    if [[ "$raw_image" =~ ^([^/]+\.[^/]+)/(.+)$ ]]; then
        repo_tag="${BASH_REMATCH[2]}"
    else
        repo_tag="$raw_image"
        [[ "$repo_tag" != *"/"* ]] && repo_tag="library/$repo_tag"
    fi

    if [[ "$repo_tag" == *":"* ]]; then
        repo=${repo_tag%%:*}
        tag=${repo_tag##*:}
    else
        repo=$repo_tag
        tag="latest"
    fi

    echo "$repo:$tag"
}

# Sanitize string to alphanumeric with underscores
alphanum() {
    echo "$1" | sed -e 's/[^a-zA-Z0-9]/_/g'
}

# Escape special characters for sed
regsave() {
    printf '%s\n' "$1" | sed -e 's/[][(){}.^$*+?|\\/]/\\&/g'
}

# Check for required dependencies
check_deps() {
    local missing=0
    for cmd in "$@"; do
        if ! type "$cmd" > /dev/null 2>&1; then
            echo -e "${R}[ERR]${NC} Missing dependency: $cmd"
            missing=1
        fi
    done
    [[ $missing -ne 0 ]] && exit 1
}
