#!/usr/bin/env bash

DEBUG=${DEBUG:-false}

d() {
  case "$DEBUG" in
    *$PLUGIN*|*$HOOK*)
      >&2 echo -e "$1"
    ;;
  esac
}
