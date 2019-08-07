#!/usr/bin/env bats

load common
fixtures branch-detail

configure_standard() {
  run git config --add hooky.plugins branch-detail
}

@test "branch-detail: exists" {
  run test -f "$TMP/.git/hooks/plugins/branch-detail/prepare-commit-msg"
  assert_success
}

@test "branch-detail: write branch name only by default" {
  configure_standard
  git checkout -b test-branch
  cp "$FIXTURE_ROOT/example.txt" "$TMP"
  git add example.txt
  git commit -m 'example.txt'

  run git log --format=%B  -1

  assert_success
  assert_output < "$FIXTURE_ROOT/test-branch-name-only.txt"
}

@test "branch-detail: write branch name and branch description" {
  configure_standard
  git checkout -b test-branch
  cp "$FIXTURE_ROOT/example.txt" "$TMP"
  git add example.txt
  cat "$FIXTURE_ROOT/test-branch-description.txt" >> "$TMP/.git/config"
  git commit -m 'example.txt'

  run git log --format=%B  -1

  assert_success
  assert_output < "$FIXTURE_ROOT/test-branch-name-and-description.txt"
}