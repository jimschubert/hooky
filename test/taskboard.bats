#!/usr/bin/env bats

load common
fixtures taskboard

configure_taskboard_standard() {
  run git config --add hooky.plugins taskboard
  run git config hooky.taskboard.prefix asdf
  run git config hooky.taskboard.urltemplate http://example.com/asdf-
}

configure_taskboard_github() {
  run git config --add hooky.plugins taskboard
  run git config hooky.taskboard.prefix pr
  run git config hooky.taskboard.separator '/'
  run git config hooky.taskboard.urltemplate 'https://github.com/jimschubert/hooky/pull/'
}

@test "taskboard: exists" {
  run test -f "$TMP/.git/hooks/plugins/taskboard/commit-msg"
  assert_success
}

@test "taskboard: sets prefix and url for jira-style branches (lowercase branch names)" {
  configure_taskboard_standard

  run git config --list

  assert_output -p < "$FIXTURE_ROOT/asdf-1234-config.txt"

  run git checkout -b asdf-1234

  run echo "test" > testing
  run git add testing

  run git commit -m 'prefix and url'
  assert_success
  assert_output -p "1 file changed"
  assert_output -p "prefix and url"
  assert_output -p "asdf-1234"

  run git log --format=%B  -1
  assert_success
  # shellcheck disable=SC2002
  assert_output -p < "$FIXTURE_ROOT/prefix.txt"
}

@test "taskboard: sets prefix and url for jira-style branches (uppercase branch names)" {
  configure_taskboard_standard

  run git config --list

  assert_output -p < "$FIXTURE_ROOT/asdf-1234-config.txt"

  run git checkout -b ASDF-1234

  run echo "test" > testing
  run git add testing

  run git commit -m 'prefix and url'
  assert_success
  assert_output -p "1 file changed"
  assert_output -p "prefix and url"
  assert_output -p "ASDF-1234"

  run git log --format=%B  -1
  assert_success
  # shellcheck disable=SC2002
  assert_output -p < "$FIXTURE_ROOT/prefix.txt"
}

@test "taskboard: sets prefix and url for github style branches (lowercase branch names)" {
  configure_taskboard_github

  run git config --list

  assert_output -p < "$FIXTURE_ROOT/pr-1-config.txt"

  run git checkout -b pr/1

  run echo "test" > testing
  run git add testing

  run git commit -m 'github style'
  assert_success
  assert_output -p "1 file changed"
  assert_output -p "github style"
  assert_output -p "pr/1"

  run git log --format=%B  -1
  assert_success
  # shellcheck disable=SC2002
  assert_output -p < "$FIXTURE_ROOT/pr-1.txt"
}

@test "taskboard: sets prefix and url for github style branches (uppercase branch names)" {

  configure_taskboard_github

  run git config --list

  assert_output -p < "$FIXTURE_ROOT/pr-1-config.txt"

  run git checkout -b PR/1

  run echo "test" > testing
  run git add testing

  run git commit -m 'github style'
  assert_success
  assert_output -p "1 file changed"
  assert_output -p "github style"
  assert_output -p "PR/1"

  run git log --format=%B  -1
  assert_success
  # shellcheck disable=SC2002
  assert_output -p < "$FIXTURE_ROOT/pr-1.txt"
}