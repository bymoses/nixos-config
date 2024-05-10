fish_vi_key_bindings
set fish_greeting # Disable greeting
bind -M insert -m default jk backward-char force-repaint
bind yy fish_clipboard_copy
bind Y fish_clipboard_copy
bind p fish_clipboard_paste

function fish_prompt
  set -l cmd_status $status
  if test -n "$SSH_TTY"
    echo -n (set_color brred)"$USER"(set_color white)'@'(set_color yellow)(prompt_hostname)' '
  end

  # echo -n (set_color magenta)(kubectl config view --minify --output 'jsonpath={..namespace}')

  echo -n 

  set_color -o
  if fish_is_root_user
    echo -n (set_color red)'# '
  end
  echo -n (set_color -b abcddf blue)(set_color 3c3c3c)' '(set_color 3c3c3c yellow)(set_color 3c3c3c)(prompt_pwd)(set_color -b 3c3c3c)(set_color 9bcddf)''
  if test -n "$IN_NIX_SHELL"
    echo -n " nix "
  end
  if test $cmd_status -ne 0
    echo -n (set_color red)"   $cmd_status"
  end
  echo -n (set_color normal)(set_color 3c3c3c)' '
  set_color normal

end

function fish_mode_prompt
  set_color -b 3c3c3c yellow
  set_color --bold white

  switch $fish_bind_mode
    case default
      echo '󰰔 '
    case insert
      echo '󰰅 '
    case replace_one
      echo '󰰠 '
    case visual
      echo '󰰬 '
    case '*'
      echo ' '
  end
  set_color normal
end
function fish_right_prompt

  if not command -sq git
    set_color normal
    return
  end

  # Get the git directory for later use.
  # Return if not inside a Git repository work tree.
  if not set -l git_dir (command git rev-parse --git-dir 2>/dev/null)
    set_color normal
    return
  end

  # Get the current action ("merge", "rebase", etc.)
  # and if there's one get the current commit hash too.
  set -l commit ""
  if set -l action (fish_print_git_action "$git_dir")
    set commit (command git rev-parse HEAD 2> /dev/null | string sub -l 7)
  end

  # Get either the branch name or a branch descriptor.
  set -l branch_detached 0
  if not set -l branch (command git symbolic-ref --short HEAD 2>/dev/null)
    set branch_detached 1
    set branch (command git describe --contains --all HEAD 2>/dev/null)
  end

  # Get the commit difference counts between local and remote.
  command git rev-list --count --left-right 'HEAD...@{upstream}' 2>/dev/null \
    | read -d \t -l status_ahead status_behind
  if test $status -ne 0
    set status_ahead 0
    set status_behind 0
  end

  # Get the stash status.
  # (git stash list) is very slow. => Avoid using it.
  set -l status_stashed 0
  if test -f "$git_dir/refs/stash"
    set status_stashed 1
  else if test -r "$git_dir/commondir"
    read -l commondir <"$git_dir/commondir"
    if test -f "$commondir/refs/stash"
      set status_stashed 1
    end
  end

  set -l porcelain_status (command git status --porcelain | string sub -l2)

  set -l status_added 0
  if string match -qr '[ACDMT][ MT]|[ACMT]D' $porcelain_status
    set status_added 1
  end
  set -l status_deleted 0
  if string match -qr '[ ACMRT]D' $porcelain_status
    set status_deleted 1
  end
  set -l status_modified 0
  if string match -qr '[MT]$' $porcelain_status
    set status_modified 1
  end
  set -l status_renamed 0
  if string match -qe R $porcelain_status
    set status_renamed 1
  end
  set -l status_unmerged 0
  if string match -qr 'AA|DD|U' $porcelain_status
    set status_unmerged 1
  end
  set -l status_untracked 0
  if string match -qe '\?\?' $porcelain_status
    set status_untracked 1
  end

  set_color -o
  set_color 3c3c3c
  echo -n ""
  set_color abcddf
  set_color -b 3c3c3c
  echo -n (date +%H:%M)
  set_color 3c3c3c
  set_color -b 3c3c3c
  if test -n "$commit"
    echo -n ' '(set_color yellow)"$commit"
  end
  if test -n "$action"
    set_color normal
    echo -n (set_color white)':'(set_color -o brred)"$action"
  end
  if test $status_ahead -ne 0
    echo -n ' '(set_color brmagenta)'󰓅 '
  end
  if test $status_behind -ne 0
    echo -n ' '(set_color brmagenta)'󰾆 '
  end
  if test $status_stashed -ne 0
    echo -n ' '(set_color cyan)' '
  end
  if test $status_added -ne 0
    echo -n ' '(set_color green)' '
  end
  if test $status_deleted -ne 0
    echo -n ' '(set_color red)' '
  end
  if test $status_modified -ne 0
    echo -n ' '(set_color blue)' '
  end
  if test $status_renamed -ne 0
    echo -n ' '(set_color magenta)' '
  end
  if test $status_unmerged -ne 0
    echo -n ' '(set_color yellow)' '
  end
  if test $status_untracked -ne 0
    echo -n ' '(set_color white)' '
  end

  set_color abcddf
  echo -n " "
  set_color -b abcddf

  if test -n "$branch"
    if test $branch_detached -ne 0
      set_color brmagenta
    else
      set_color 3c3c3c
    end
    echo -n "$branch "
  end

  set_color normal
end
