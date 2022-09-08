#!/usr/bin/env bash
# 
# zs - is a zettel selector using fzf
# features:
#  - it accepts multiple selection (using tab)
#  - copy multiple selection to clipboard (mapped to ctrl-y)
#  - clear selection (mapped to ctrl-l)
#  - populates (n)vim quickfix list with zettel titles (enter)
#

SRC_FOLDER=$HOME/notes/

main() {
    cd "$SRC_FOLDER"
    grep --max-count=1 --with-filename "^#[[:space:]][[:alnum:]]" *.md | sed 's/:#[[:space:]]/ | /g' |  fzf --tac --multi \
                                --layout=reverse \
                                --preview "echo {} | sed 's/[[:space:]].*//g' | head | xargs batcat --style=plain --color=always" \
                                --preview-window=wrap \
                                --bind '?:toggle-preview' \
                                --bind 'ctrl-l:clear-selection' \
                                --bind "ctrl-y:execute(printf '%s\n' {+} | xclip -selection clipboard)" \
                                --bind 'enter:execute(echo {+} | grep -o "[0-9]\+\.md" | xargs -o $EDITOR -c "silent bufdo grepadd ^\#  %")'
}

main
