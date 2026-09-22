# ~/.bashrc -- sourced by interactive bash shells.
# Keep this cheap; it runs on every new shell.

# If not running interactively, don't do anything. (Cron, scp, rsync, etc.)
case $- in
    *i*) ;;
      *) return;;
esac

# ---- history -----------------------------------------------------------
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups   # no dupes, no leading-space entries
HISTIGNORE='ls:ll:cd:pwd:exit:clear:history'
shopt -s histappend                 # append, don't clobber, across sessions
shopt -s checkwinsize
shopt -s globstar                   # ** matches recursively
shopt -s cdspell                    # fix small typos in cd paths

# Persist history between shells without waiting for logout.
PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND:-}"

# ---- PATH --------------------------------------------------------------
# Prepend local bins if they exist. Order matters; last prepend wins.
for d in "$HOME/.local/bin" "$HOME/bin" "$HOME/.cargo/bin"; do
    [[ -d "$d" ]] && PATH="$d:$PATH"
done
export PATH

# ---- editor / pager ----------------------------------------------------
export EDITOR="${EDITOR:-vim}"
export VISUAL="$EDITOR"
export PAGER=less
export LESS='-R -F -X -i -M'       # raw colors, quit-if-one-screen, keep -X so tmux scrollback works
export MANPAGER='less -R'

# ---- locale ------------------------------------------------------------
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# ---- prompt ------------------------------------------------------------
# Green user@host, blue path, then git branch in yellow. Falls back to a plain
# prompt if git isn't installed.
__prompt_git() {
    command -v git >/dev/null 2>&1 || return
    local branch
    branch="$(git symbolic-ref --short HEAD 2>/dev/null)" || return
    printf ' \033[33m(%s)\033[0m' "$branch"
}

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__prompt_git)\$ '

# ---- misc --------------------------------------------------------------
# Don't put secrets in history.
export GIT_TERMINAL_PROMPT=0       # fail fast instead of hanging for a password

# coloured grep / ls when available
if command -v dircolors >/dev/null 2>&1; then
    eval "$(dircolors -b)"
fi
alias grep='grep --color=auto'

# ---- local overrides ---------------------------------------------------
# Anything machine-specific goes in ~/.bashrc.local (git-ignored).
[[ -f "$HOME/.bashrc.local" ]] && source "$HOME/.bashrc.local"

# ---- aliases -----------------------------------------------------------
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
