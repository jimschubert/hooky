#!/usr/bin/env bash

# shellcheck source=/usr/local/Cellar/git/2.15.1/libexec/git-core/git-sh-setup
. "$(git --exec-path)/git-sh-setup"

hooky() {
  local hook="$1"
  local ret=0
  if [ -n "${hook:+set}" ]; then
    shift
    plugins=$(git config --get-all hooky.plugins)
    for plugin in $plugins; do
      export hook_path="${GIT_DIR}/hooks/plugins/${plugin}/${hook}"
      # Verify $PLUGINS_DIR/$plugin/$hook file permissions.
      if [ -f "${hook_path}" ]; then
        # shellcheck disable=SC1090
       env HOOK="$hook" HOOK_PATH="$hook_path" PLUGIN="$plugin" "${hook_path}" "$@"
       ret=$?
       if [[ $ret != 0 ]]; then
        exit $ret
       fi
      fi
    done
  fi
  unset hook
  unset ret
}
