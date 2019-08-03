# hooky

Globally orchestrate shared git hooks.

## Setup

Clone this repository to a shared location. `~/.config/hooky` is the recommended location.

```
mkdir ~/.config
git clone https://github.com/jimschubert/hooky.git ~/.config/hooky
```

Then, just configure git to use hooky as your githooks global template directory:

```
git config --global init.templatedir '~/.config/hooky/git/'
```

## Usage

Add one of the supported plugins to the `hooky.plugins` config key. This is a multi-valued key.

For example, add `json-validator` and `changes`:

```bash
git config --add hooky.plugins json-validator
git config --add hooky.plugins changes
```

Remove a plugin individually:

```bash
git config --unset hooky.plugins changes
```

Or uninstall hooky from a repo completely:

```bash
git config --unset-all hooky.plugins
```

## Contributing

### Testing

Tests are written with bats. Please follow [installation intructions](https://github.com/bats-core/bats-core) before running tests.