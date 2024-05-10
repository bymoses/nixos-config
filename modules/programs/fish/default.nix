{
  pkgs,
    lib,
    ...
}:
let
  config = lib.readFile ./config.fish;
in {
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      freshfetch
      ${config}

      kubectl completion fish | source
      complete -k -c k -n '__kubectl_requires_order_preservation && __kubectl_prepare_completions' -f -a '$__kubectl_comp_results'
      complete -c k -n 'not __kubectl_requires_order_preservation && __kubectl_prepare_completions' -f -a '$__kubectl_comp_results'
      complete -c k -n '__kubectl_clear_perform_completion_once_result'
    '';
    plugins = [
# Enable a plugin (here grc for colorized command output) from nixpkgs
    { name = "grc"; src = pkgs.fishPlugins.grc.src; }
    ];
  };
}
