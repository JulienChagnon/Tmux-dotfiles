# Portable tmux setup

My tmux configuration, stripped of anything tied to a work machine. Drop these two
files on a new laptop and the setup behaves the same.

| File | Goes to |
| --- | --- |
| `tmux.conf` | `~/.tmux.conf` |
| `tmux.bashrc` | `~/.config/tmux/tmux.bashrc`, sourced from `~/.bashrc` |

## Install

```bash
cp tmux.conf ~/.tmux.conf
mkdir -p ~/.config/tmux && cp tmux.bashrc ~/.config/tmux/tmux.bashrc
echo '[ -f ~/.config/tmux/tmux.bashrc ] && . ~/.config/tmux/tmux.bashrc' >> ~/.bashrc
```

Reload inside a running server with `tmux source-file ~/.tmux.conf`.

Requires tmux 3.2 or newer for `display-popup` and `terminal-features`; written
against 3.4. No plugin manager, no tpm, nothing to clone.

The popup bindings shell out to external tools, so install the ones you want:
`fzf`, `fd`, `bat`, `nvim`, `lazygit`. Everything else works without them.

## Keys

Prefix is `C-a`, not `C-b`. `C-a C-a` sends a literal `C-a` through to the shell.

**Windows** — `q` or `c` new, `r` rename (prompt prefilled with the current name),
`&` kill, `,` / `.` previous and next, `Tab` last, `1`–`9` jump. Windows are
1-indexed and renumber themselves when one closes.

**Panes** — `h` splits below, `v` splits beside, `x` kills, `z` zooms, arrows move,
`C-`arrows resize in steps of 5 and repeat without re-pressing the prefix.
`Space` cycles layouts, picking a sensible rotation for 2, 3, 4 and more panes
rather than tmux's flat list. A zoomed pane shows a `ZOOMED` marker in the border.

**Copy** — vi keys. `y` enters copy mode, `v` starts a selection, `y` copies and
exits, `p` pastes. Copies reach the system clipboard over OSC 52, which means
selections made on a remote host land in the local clipboard.

**Popups** — `g` a shell, `f` an fzf file picker that opens the result in nvim,
`G` lazygit.

## Choices worth knowing about

**Window names stay put.** tmux's `automatic-rename` relabels a window every time
the foreground process changes. Here the automatic name is allowed to land once,
then renaming is switched off for that window, so the label only changes when you
ask. `R` turns automatic naming back on for the current window.

Separately, some CLI tools run an explicit `tmux rename-window` on launch, which
`allow-rename off` does not stop. The `after-rename-window` hook remembers every
deliberate rename in `@pinned_name` and bounces that one name back. `@rename_guard`
ships empty, which makes the bounce a no-op; set it to the name the offending tool
forces if you hit this, or delete the hook.

**No OSC colour queries.** The `Tc`/`RGB` terminal flags are deliberately absent;
they make tmux probe the terminal for its colours, and the replies leak into shell
input as junk on reconnect. True colour still works through the explicit
`terminal-overrides` escape sequences, and `BACKGROUND`/`COLORFGBG` in
`tmux.bashrc` tell editors the background is dark without a probe.

**Focus events off, escape-time 5, assume-paste-time 0.** Tuned for working over
SSH: fast `Esc` handling in vim without swallowing fast typing, and no focus
reporting to hang a CLI on startup.

**Quiet.** Activity is tracked and shown in the status line, but bells and visual
alerts are all off.

Mouse mode is on, scrollback is 50k lines.

The `tmux_conf_*` variables in the middle of the file are leftovers from the
oh-my-tmux layout the config started from. They are inert plain shell assignments
unless you install oh-my-tmux; the settings that actually take effect are the
`set`, `setw` and `bind` lines around them. Harmless to keep, harmless to delete.
