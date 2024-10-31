gdn() {
  if test "$#" = 0; then
    (
      git diff --color
      git ls-files --others --exclude-standard |
        while read -r i; do git diff --color -- /dev/null "$i"; done
    ) | `git config --get core.pager`
  else
    git diff "$@"
  fi
}

