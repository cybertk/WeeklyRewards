#!/usr/bin/env bash
set -euo pipefail

# Generate changelog.lua from the 10 newest version-sorted Git tags.
# Usage: ./generate-changelog-lua.sh [output-file]
# Timestamps are Unix timestamps (UTC, timezone-independent).

output_file="${1:-changelog.lua}"
tag_limit=10

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: run this script inside a Git repository." >&2
    exit 1
fi

tags=()
while IFS= read -r tag; do
    [[ -n "$tag" ]] && tags[${#tags[@]}]="$tag"
done < <(git tag --sort=-version:refname)

if ((${#tags[@]} == 0)); then
    echo "Error: no Git tags found." >&2
    exit 1
fi

tag_count=${#tags[@]}
if ((tag_count > tag_limit)); then
    tag_count=$tag_limit
fi

lua_quote() {
    local value="$1"
    value=${value//\\/\\\\}
    value=${value//\"/\\\"}
    value=${value//$'\r'/}
    value=${value//$'\n'/\\n}
    value=${value//$'\t'/\\t}
    printf '"%s"' "$value"
}

{
    printf 'changelog = {\n'

    for ((i = 0; i < tag_count; i++)); do
        tag="${tags[$i]}"

        # %creatordate:unix works for both lightweight and annotated tags.
        timestamp=$(git for-each-ref --format='%(creatordate:unix)' "refs/tags/$tag")
        [[ -n "$timestamp" ]] || timestamp=$(git log -1 --format=%ct "$tag")
        [[ -n "$timestamp" ]] || timestamp=0

        printf '    { v='
        lua_quote "$tag"
        printf ', date=%s, changes={\n' "$timestamp"

        if ((i + 1 < ${#tags[@]})); then
            older_tag="${tags[$((i + 1))]}"
            range="${older_tag}..${tag}"
        else
            range="$tag"
        fi

        # NUL-delimit full commit messages so multiline messages remain intact.
        while IFS= read -r -d '' message; do
            # Trim surrounding whitespace/newlines.
            message="${message#"${message%%[!$'\n\r\t ']*}"}"
            message="${message%"${message##*[!$'\n\r\t ']}"}"
            [[ -z "$message" ]] && continue

            # Replace actual line breaks with the literal marker |n.
            message=${message//$'\r\n'/$'\n'}
            message=${message//$'\n'/|n}

            printf '        '
            lua_quote "$message"
            printf ',\n'
        done < <(git log --no-merges --format='%B%x00' "$range")

        printf '    }},\n'
    done

    printf '}\n'
} > "$output_file"

echo "Generated $output_file with $tag_count tag entries."
