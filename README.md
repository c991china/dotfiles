# dotfiles

My shell config. Boring on purpose. No zsh framework, no 3000-line `.vimrc`,
no plugin manager you have to install before anything works.

I keep this minimal because every time I went full "power user" I spent more
time fixing my config than writing code. This is the version that survived.

## What's in here

| file               | what it does |
|--------------------|--------------|
| `.bashrc`          | prompt, history, PATH, sources `.aliases` |
| `.aliases`         | short commands I type 50x a day |
| `.inputrc`         | case-insensitive tab completion, history search on Up/Down |
| `.gitconfig`       | aliases + sane defaults (rebase on pull, prune on fetch) |
| `.vimrc`           | modest vim config, no plugins required |
| `.tmux.conf`       | C-a prefix, mouse on, vi keys |
| `.editorconfig`    | tabs/spaces per language so editors stop fighting |
| `.gitignore_global`| OS/editor junk I never want to commit |

## Install

```bash
git clone https://github.com/c991china/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` symlinks each file into `$HOME`. If a real file already exists
(your old `.bashrc`, say) it is moved to `~/.dotfiles-backup/<timestamp>/`
first, so nothing is silently clobbered.

Run it twice and nothing bad happens. It is idempotent.

Preview without touching anything:

```bash
DRY_RUN=1 ./install.sh
```

## Sample output

```
$ ./install.sh
[dotfiles] backing up existing files to /home/me/.dotfiles-backup/2026-04-02-101533
  backup  .bashrc -> .dotfiles-backup/2026-04-02-101533/.bashrc
  link    .bashrc
  link    .aliases
  link    .inputrc
  link    .gitconfig
  skip    .vimrc (already correct)
  ...
[dotfiles] done. Open a new shell or: source ~/.bashrc
```

## Gotchas

- **`.bashrc` is not read by non-interactive shells.** If a script or a cron job
  "can't find" a function from here, that's why. Don't put logic in dotfiles that
  scripts depend on.
- **macOS ships bash 3.2.** It's ancient (no `mapfile`, no associative arrays
  without care). If you need modern bash, `brew install bash` and change your
  login shell. I use bash 5.2 on Linux and 3.2 on the Mac and the config guards
  for it.
- **`.gitconfig` has a placeholder identity.** Change it or every commit will be
  authored by `Your Name <you@example.com>`. See the top of the file.
- **Symlinks and some editors.** A couple of editors rewrite config in place and
  will replace your symlink with a real file. If a dotfile "stops tracking",
  check with `ls -l ~/.vimrc`.
- On a fresh machine, `.gitconfig` referencing an `includeIf` for work dirs will
  error if that file doesn't exist. It's commented out; uncomment when you need it.

## Notes

Tested on Ubuntu 24.04 (bash 5.2), Debian 12, and macOS 14 (bash 3.2 + zsh as
login shell). I don't use zsh day-to-day so the zsh story here is "it mostly
works because zsh reads `.inputrc` for some things and ignores the rest."

`install.sh` needs `bash` (any 4+), `ln`, and `mkdir`. Nothing else.
