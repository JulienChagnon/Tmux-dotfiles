# tmux-related shell setup. Source this from ~/.bashrc:
#
#   [ -f ~/.config/tmux/tmux.bashrc ] && . ~/.config/tmux/tmux.bashrc
#
# Everything here pairs with tmux.conf in the same folder.

# ─── Colour hints without OSC queries ────────────────────────────────
# Tell neovim/vim/tmux the background is dark by environment instead of
# letting them probe the terminal. OSC 10/11 responses can leak into
# shell input as garbage text, especially on SSH reconnect.
export BACKGROUND=dark
export COLORFGBG="15;0"

# Same reason: do not run `eval "$(resize)"` on shell startup.

# ─── DISPLAY inside tmux ─────────────────────────────────────────────
# A tmux server outlives the SSH/X session that spawned it, so a pane's
# inherited DISPLAY goes stale. Pull the server's current value instead.
if [ -n "$TMUX" ]; then
    eval "$(tmux show-environment -s DISPLAY)"
fi

# ─── Auto-attach ─────────────────────────────────────────────────────
# Interactive shells outside tmux jump into a session named after the
# current directory, creating it if needed. Skipped under VS Code's
# integrated terminal, which does its own session handling.
if [ -z "$VSCODE_IPC_HOOK_CLI" ] && [ -z "$TMUX" ] && [ "$TERM_PROGRAM" != "vscode" ]; then
    _tmux_session=$(basename "$PWD")
    if tmux has-session -t "$_tmux_session" 2>/dev/null; then
        exec tmux attach-session -t "$_tmux_session"
    else
        exec tmux new-session -s "$_tmux_session"
    fi
fi

# ─── Aliases ─────────────────────────────────────────────────────────
# clear also drops the scrollback, so mouse-wheel scroll starts clean
alias c='clear && tmux clear-history'
