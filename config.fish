# fish — Tokyo Night rice (ported from zsh)
# Reload: exec fish

fish_add_path -g $HOME/.local/bin
fish_add_path -g $HOME/.railway/bin

set -gx RAILWAY_HOME $HOME/.railway
set -gx STARSHIP_CONFIG $HOME/.config/zsh/starship.toml

if status is-interactive
    # Aliases
    alias ls 'ls --color=auto'
    alias ll 'ls -lah --group-directories-first'
    alias la 'ls -A'
    alias vim nvim
    alias grep 'grep --color=auto'
    alias g git
    alias gs 'git status -sb'
    alias gd 'git diff'
    alias gl 'git log --oneline -20'

    if command -q bat
        alias cat 'bat --paging=never'
    end
    if command -q eza
        alias ls 'eza --icons --group-directories-first'
        alias ll 'eza -lah --icons --group-directories-first'
    end

    # fzf (Ctrl-T files, Ctrl-R history, Alt-C cd)
    set -gx FZF_DEFAULT_OPTS "
      --height=40% --layout=reverse --border
      --color=bg+:#292e42,bg:#24283b,spinner:#bb9af7,hl:#7aa2f7
      --color=fg:#c0caf5,header:#7aa2f7,info:#7dcfff,pointer:#bb9af7
      --color=marker:#9ece6a,fg+:#c0caf5,prompt:#7aa2f7,hl+:#7dcfff
    "
    if functions -q fzf_key_bindings
        fzf_key_bindings
    end

    if command -q zoxide
        zoxide init fish | source
    end

    if command -q starship
        starship init fish | source
    end
end
