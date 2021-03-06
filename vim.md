# Vim Customization

_Last updated on August 22nd, 2017_

## Editing

### General

+ `ctrl + s` to save the current file.
+ `ctrl + q` to close the current file.
+ `ctrl + p` to bring up the file explorer.
+ `ctrl + t` to open a new tab.

### Column Select

1. `ctrl + v` to enable the select mode.
1. `c` to change the content.
1. `esc esc` to apply the changes.

## File Handling

### Renaming

+ `<L> + n` to rename the current file.

### Quick Access

+ `<L> + sc` to open the Rails schema file.

### Find in Files

+ `\` to search in files.
+ `F` to find current word in files.

## Ruby Tools

### Debugging

+ `<L> + bye` = `byebug`
+ `<L> + pry` = `binding.pry.`

### Block Builders

Provided by the [ruby.vim](/files/vim/macros/ruby.vim) file.

+ `<L> + cls` = `class`, which also includes an `initialize` method.
+ `<L> + mod` = `module`, which also prompts for a method name.
+ `<L> + de` = `def`.
+ `<L> + di` = `def` for an `initialize` method.
+ `<L> + rsp` = `RSpec.describe`, and wraps the provided name in single quotes.
+ `<L> + rsm` = `RSpec.describe`, and does not wrap the provided name in single quotes.
+ `<L> + dsc` = `describe`.
+ `<L> + con` = `context`.
+ `<L> + it` = `it`.
+ `<L> + let` = `let`.

### Frozen String Literal

Both of the following insert `# frozen_string_literal: true`.

+ `<L> + frz`
+ `<L> + fsl`

### Navigation

+ `]m` start of next method.
+ `]M` end of current method.
+ `[m` start of previous method.
+ `[M` end of previous method.
+ `]]` start of next method or class.
+ `[[` end of previous method or class.
+ `%` matching keyword.

### Rubocop

+ `<L> + ru` to run Rubocop on the current file.

### RSpec

+ `<L> + t` to run the current test.
+ `<L> + s` to run the nearest test.
+ `<L> + l` to re-run the last test.
+ `<L> + a` to run all tests.

## Git

Thanks to the Vim Fugitive plugin

+ `Gedit`
+ `Gdiff`
+ `Gstatus`
+ `Gcommit`
+ `Gmove`
+ `Gremove`
+ `Ggrep`
+ `Gread`
+ `Gbrowse`
+ `Gwrite`
+ `Git [command]` to run a git command.
+ `Git! [command]` to run a git command and view its output.

## Misc

+ `q` to close the quick window.
