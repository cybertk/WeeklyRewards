#!/usr/bin/env bash
set -euo pipefail

# Generate changelog.lua from the 10 newest version-sorted Git tags.
# Usage: ./generate-changelog-lua.sh [output-file]
# Timestamps are Unix timestamps (UTC, timezone-independent).
#
# Each release's notes are rewritten for players:
#   - grouped by conventional-commit type (feat, then fix, then perf, then others)
#   - original order is kept within a type
#   - issue references such as #44 and (#44) are removed
#   - "feat:" and "perf:" prefixes are dropped
#   - "fix:" is replaced with "Fixed an issue where "
#   - the first character is capitalized

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

trim_edges() {
    local value="$1"
    value="${value#"${value%%[!$'\n\r\t ']*}"}"
    value="${value%"${value##*[!$'\n\r\t ']}"}"
    printf '%s' "$value"
}

capitalize_first() {
    local value="$1"
    local first
    [[ -z "$value" ]] && return 0
    first=$(printf '%s' "${value:0:1}" | tr '[:lower:]' '[:upper:]')
    printf '%s%s' "$first" "${value:1}"
}

# Print "group<US>type<US>message" or return 1 when the commit should be skipped.
# group 0 is a typed commit; group 1 is an unprefixed commit (sorted last).
prepare_change() {
    local message="$1"
    local first_line rest type_key type_sort body group

    message=$(trim_edges "$message")
    [[ -z "$message" ]] && return 1

    message=${message//$'\r\n'/$'\n'}
    message=${message//$'\r'/$'\n'}
    # Drop GitHub issue refs (#44, (#44)) and whitespace that only separated them.
    message=$(printf '%s\n' "$message" | sed -E 's/[[:space:]]*\(?#[0-9]+\)?//g; s/[[:space:]]+$//')
    message=$(trim_edges "$message")
    [[ -z "$message" ]] && return 1

    first_line="${message%%$'\n'*}"
    if [[ "$message" == *$'\n'* ]]; then
        rest="${message#*$'\n'}"
    else
        rest=""
    fi

    # 1 feat, 2 fix, 3 perf, then any other type. Untyped commits use group 1.
    # Keep the pattern in a variable so ")" and "!" are not parsed as [[ syntax.
    local type_re='^([A-Za-z][A-Za-z0-9]*)(\([^)]*\))?(!)?:[[:space:]]*(.*)$'
    type_sort="~"
    group=1
    if [[ "$first_line" =~ $type_re ]]; then
        type_key=$(printf '%s' "${BASH_REMATCH[1]}" | tr '[:upper:]' '[:lower:]')
        body="${BASH_REMATCH[4]}"
        group=0
        case "$type_key" in
            feat)
                type_sort="1-feat"
                first_line="$body"
                ;;
            fix)
                type_sort="2-fix"
                if [[ -n "$body" ]]; then
                    first_line="Fixed an issue where $body"
                else
                    first_line="Fixed an issue where"
                fi
                ;;
            perf)
                type_sort="3-perf"
                first_line="$body"
                ;;
            *)
                type_sort="4-${type_key}"
                ;;
        esac
    fi

    if [[ -n "$rest" ]]; then
        if [[ -n "$first_line" ]]; then
            message="${first_line}"$'\n'"${rest}"
        else
            message="$rest"
        fi
    else
        message="$first_line"
    fi

    message=$(trim_edges "$message")
    [[ -z "$message" ]] && return 1

    message=$(capitalize_first "$message")
    message=${message//$'\n'/|n}
    message=${message//$'\x1f'/}

    printf '%s\x1f%s\x1f%s' "$group" "$type_sort" "$message"
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

        records=()
        index=0
        # NUL-delimit full commit messages so multiline messages remain intact.
        while IFS= read -r -d '' message; do
            record=""
            if ! record=$(prepare_change "$message"); then
                continue
            fi
            # prepare_change prints group<US>type<US>message.
            # Store group<US>type<US>index<US>message so each type keeps commit order.
            group="${record%%$'\x1f'*}"
            rest="${record#*$'\x1f'}"
            type_sort="${rest%%$'\x1f'*}"
            message="${rest#*$'\x1f'}"
            records[${#records[@]}]=$(printf '%s\x1f%s\x1f%05d\x1f%s' "$group" "$type_sort" "$index" "$message")
            index=$((index + 1))
        done < <(git log --no-merges --format='%B%x00' "$range")

        if ((${#records[@]} > 0)); then
            while IFS= read -r record; do
                message="${record#*$'\x1f'}"
                message="${message#*$'\x1f'}"
                message="${message#*$'\x1f'}"
                printf '        '
                lua_quote "$message"
                printf ',\n'
            done < <(printf '%s\n' "${records[@]}" | sort -t $'\x1f' -k1,1n -k2,2 -k3,3n)
        fi

        printf '    }},\n'
    done

    printf '}\n'
} > "$output_file"

echo "Generated $output_file with $tag_count tag entries."
