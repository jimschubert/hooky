#!/usr/bin/env bats

load common
fixtures json-validator

configure_json_validator_standard() {
  git config --add hooky.plugins json-validator
}

configure_json_validator_jq() {
  git config --add hooky.plugins json-validator
  git config hooky.json-validator.command 'jq -e "."'
}

@test "json-validator: exists" {
  run test -f "$TMP/.git/hooks/plugins/json-validator/pre-commit"
  assert_success
}

##
# python -m json.tool
##

@test "json-validator: aborts commit for invalid chars in file (standard validator)" {
  configure_json_validator_standard

  cp "$FIXTURE_ROOT/invalid-chars.json" "$TMP"
  git add invalid-chars.json

  run git commit -m 'invalid-char.json'

  assert_failure

  assert_output -p < "$FIXTURE_ROOT/header.txt"
  assert_output -p 'invalid-chars.json'
  assert_output -p < "$FIXTURE_ROOT/footer.txt"
}

@test "json-validator: aborts commit for invalid chars in file in subdirectory (standard validator)" {
  configure_json_validator_standard

  mkdir -p "$TMP/a/b/c"
  cp "$FIXTURE_ROOT/invalid-chars.json" "$TMP"/a/b/c
  git add a/b/c/invalid-chars.json

  run git commit -m 'invalid-char.json'

  assert_failure

  assert_output -p < "$FIXTURE_ROOT/header.txt"
  assert_output -p 'a/b/c/invalid-chars.json'
  assert_output -p < "$FIXTURE_ROOT/footer.txt"
}

@test "json-validator: aborts commit for empty json (standard validator)" {
  configure_json_validator_standard

  cp "$FIXTURE_ROOT/empty-file.json" "$TMP"
  git add empty-file.json

  run git commit -m 'empty-file.json'

  assert_failure

  assert_output -p < "$FIXTURE_ROOT/header.txt"
  assert_output -p 'empty-file.json'
  assert_output -p < "$FIXTURE_ROOT/footer.txt"
}

@test "json-validator: aborts commit for invalid obj in file (standard validator)" {
  configure_json_validator_standard

  cp "$FIXTURE_ROOT/invalid-obj.json" "$TMP"
  git add invalid-obj.json

  run git commit -m 'invalid-obj.json'

  assert_failure

  assert_output -p < "$FIXTURE_ROOT/header.txt"
  assert_output -p 'invalid-obj.json'
  assert_output -p < "$FIXTURE_ROOT/footer.txt"
}

@test "json-validator: aborts commit for invalid obj in file in subdirectory (standard validator)" {
  configure_json_validator_standard

  mkdir -p "$TMP/a/b/c"
  cp "$FIXTURE_ROOT/invalid-obj.json" "$TMP"/a/b/c
  git add a/b/c/invalid-obj.json

  run git commit -m 'invalid-obj.json'

  assert_failure

  assert_output -p < "$FIXTURE_ROOT/header.txt"
  assert_output -p 'a/b/c/invalid-obj.json'
  assert_output -p < "$FIXTURE_ROOT/footer.txt"
}

@test "json-validator: aborts commit for empty json in subdirectory (standard validator)" {
  configure_json_validator_standard

  mkdir -p "$TMP/a/b/c"
  cp "$FIXTURE_ROOT/empty-file.json" "$TMP"/a/b/c
  git add a/b/c/empty-file.json

  run git commit -m 'empty-file.json'

  assert_failure

  assert_output -p < "$FIXTURE_ROOT/header.txt"
  assert_output -p 'a/b/c/empty-file.json'
  assert_output -p < "$FIXTURE_ROOT/footer.txt"
}

@test "json-validator: succeed for empty object (standard validator)" {
  configure_json_validator_standard

  cp "$FIXTURE_ROOT/empty-object.json" "$TMP"
  git add empty-object.json

  run git commit -m 'empty-object.json'

  assert_success
}

@test "json-validator: succeed for empty object in subdirectory (standard validator)" {
  configure_json_validator_standard

  mkdir -p "$TMP/a/b/c"
  cp "$FIXTURE_ROOT/empty-object.json" "$TMP"/a/b/c
  git add a/b/c/empty-object.json

  run git commit -m 'empty-object.json'

  assert_success
}

@test "json-validator: succeed for valid object (standard validator)" {
  configure_json_validator_standard

  cp "$FIXTURE_ROOT/valid.json" "$TMP"
  git add valid.json

  run git commit -m 'valid.json'

  assert_success
}

@test "json-validator: succeed for valid object in subdirectory (standard validator)" {
  configure_json_validator_standard

  mkdir -p "$TMP/a/b/c"
  cp "$FIXTURE_ROOT/valid.json" "$TMP"/a/b/c
  git add a/b/c/valid.json

  run git commit -m 'valid.json'

  assert_success
}

##
# jq "."
##

@test "json-validator: aborts commit for invalid chars in file (jq validator)" {
  configure_json_validator_jq

  cp "$FIXTURE_ROOT/invalid-chars.json" "$TMP"
  git add invalid-chars.json

  run git commit -m 'invalid-char.json'

  assert_failure

  assert_output -p < "$FIXTURE_ROOT/header.txt"
  assert_output -p 'invalid-chars.json'
  assert_output -p < "$FIXTURE_ROOT/footer.txt"
}

@test "json-validator: aborts commit for invalid chars in file in subdirectory (jq validator)" {
  configure_json_validator_jq

  mkdir -p "$TMP/a/b/c"
  cp "$FIXTURE_ROOT/invalid-chars.json" "$TMP"/a/b/c
  git add a/b/c/invalid-chars.json

  run git commit -m 'invalid-char.json'

  assert_failure

  assert_output -p < "$FIXTURE_ROOT/header.txt"
  assert_output -p 'a/b/c/invalid-chars.json'
  assert_output -p < "$FIXTURE_ROOT/footer.txt"
}

# NOTE: jq is actually actually appears to be incorrect to treat an empty file as valid json, as this doesn't match the 'value' definition of JSON spec:
# A value can be a string in double quotes, or a number, or true or false or null, or an object or an array. These structures can be nested.
@test "json-validator: aborts commit for empty json (jq validator)" {
  configure_json_validator_jq

  cp "$FIXTURE_ROOT/empty-file.json" "$TMP"
  git add empty-file.json

  run git commit -m 'empty-file.json'

  assert_failure

  assert_output -p < "$FIXTURE_ROOT/header.txt"
  assert_output -p 'empty-file.json'
  assert_output -p < "$FIXTURE_ROOT/footer.txt"
}

@test "json-validator: succeeds for empty json with defer-empty=true (jq validator)" {
  configure_json_validator_jq
  git config hooky.json-validator.defer-empty true
  cp "$FIXTURE_ROOT/empty-file.json" "$TMP"
  git add empty-file.json

  run git commit -m 'empty-file.json'

  assert_success
}

@test "json-validator: aborts commit for empty json in subdirectory (jq validator)" {
  configure_json_validator_jq

  mkdir -p "$TMP/a/b/c"
  cp "$FIXTURE_ROOT/empty-file.json" "$TMP"/a/b/c
  git add a/b/c/empty-file.json

  run git commit -m 'empty-file.json'

  assert_failure

  assert_output -p < "$FIXTURE_ROOT/header.txt"
  assert_output -p 'a/b/c/empty-file.json'
  assert_output -p < "$FIXTURE_ROOT/footer.txt"
}

@test "json-validator: succeeds for empty json in subdirectory with defer-empty=true (jq validator)" {
  configure_json_validator_jq

  git config hooky.json-validator.defer-empty true
  mkdir -p "$TMP/a/b/c"
  cp "$FIXTURE_ROOT/empty-file.json" "$TMP"/a/b/c
  git add a/b/c/empty-file.json

  run git commit -m 'empty-file.json'

  assert_success
}

@test "json-validator: aborts commit for invalid obj in file (jq validator)" {
  configure_json_validator_jq

  cp "$FIXTURE_ROOT/invalid-obj.json" "$TMP"
  git add invalid-obj.json

  run git commit -m 'invalid-obj.json'

  assert_failure

  assert_output -p < "$FIXTURE_ROOT/header.txt"
  assert_output -p 'invalid-obj.json'
  assert_output -p < "$FIXTURE_ROOT/footer.txt"
}

@test "json-validator: aborts commit for invalid obj in file in subdirectory (jq validator)" {
  configure_json_validator_jq

  mkdir -p "$TMP/a/b/c"
  cp "$FIXTURE_ROOT/invalid-obj.json" "$TMP"/a/b/c
  git add a/b/c/invalid-obj.json

  run git commit -m 'invalid-obj.json'

  assert_failure

  assert_output -p < "$FIXTURE_ROOT/header.txt"
  assert_output -p 'a/b/c/invalid-obj.json'
  assert_output -p < "$FIXTURE_ROOT/footer.txt"
}

@test "json-validator: succeed for empty object (jq validator)" {
  configure_json_validator_jq

  cp "$FIXTURE_ROOT/empty-object.json" "$TMP"
  git add empty-object.json

  run git commit -m 'empty-object.json'

  assert_success
}

@test "json-validator: succeed for empty object in subdirectory (jq validator)" {
  configure_json_validator_jq

  mkdir -p "$TMP/a/b/c"
  cp "$FIXTURE_ROOT/empty-object.json" "$TMP"/a/b/c
  git add a/b/c/empty-object.json

  run git commit -m 'empty-object.json'

  assert_success
}

@test "json-validator: succeed for valid object (jq validator)" {
  configure_json_validator_jq

  cp "$FIXTURE_ROOT/valid.json" "$TMP"
  git add valid.json

  run git commit -m 'valid.json'

  assert_success
}

@test "json-validator: succeed for valid object in subdirectory (jq validator)" {
  configure_json_validator_jq

  mkdir -p "$TMP/a/b/c"
  cp "$FIXTURE_ROOT/valid.json" "$TMP"/a/b/c
  git add a/b/c/valid.json

  run git commit -m 'valid.json'

  assert_success
}
