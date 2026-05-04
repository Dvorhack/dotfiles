{ ... }:

{
  programs.zsh = {
    enable = true;
    initExtra = ''
    '';
    shellAliases = {
      sudo = ''sudo env "PATH=$PATH"'';
      grep = "grep --color";
    };

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    sessionVariables = {
      COLORTERM = "truecolor";
      TERM = "xterm-256color";
      EDITOR = "vim";
    };

    oh-my-zsh = {
      enable = true;
      theme = "gnzh";
      plugins = [
        "git"
        "history"
      ];
    };
  };
}
