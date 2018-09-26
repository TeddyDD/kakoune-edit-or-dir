# Kakoune Edit or dir

Sometimes, when I use `edit` command in Kakoune, I press enter too
early. Kakoune complains `foo is a directory`. I know Kakoune, thank you
very much. What if editing directory would show you interactive file browser
instead?

## Gif time!

![gif](edit-or-dir.gif)

## Installation

Source `edit-or-dir.kak` from your `kakrc` or let your plugin manager do
the job. For convenience I recommend aliasing `edit-or-dir` command to `e`.
I **do not** recommend aliasing or overriding built-in edit command, since
it might broke other scripts. Replacing `e` alias is fine, scripts should
not relay on aliases anyway.

```
unalias global e edit
alias global e edit-or-dir
```

## Usage

```
edit-or-dir PATH

PATH - relative or absolute path to file or directory.
       . means current directory
       .. means parent directory
       If PATH is directory, file browser in temporary buffer *dir* will be opened
```

When in `*dir*` buffer you can use `<ret>` to open selected file, and
`<backspace>` to go to parent directory.

## Changelog

- 0.1 2018-09-26:
    - Kakoune v2018.09.04
    - initial release

