load libs/load

export BUILD="$(cd "$BATS_TEST_DIRNAME" && cd ../git && pwd)"
export TMP="$BATS_TEST_DIRNAME/tmp"

fixtures() {
  FIXTURE_ROOT="$BATS_TEST_DIRNAME/fixtures/$1"
}

setup() {
	mkdir "$TMP"
	pushd .
	cd "$TMP" && git init && git config init.templatedir "$BUILD" && git init  && echo "Initial" >> Initial && git add Initial && git commit -m 'Initial Commit'
}

teardown() {
	rm -rf "$TMP"
	popd
}
