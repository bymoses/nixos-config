{ pkgs, ... }: {
  home.packages = with pkgs; [
    nodePackages.typescript-language-server # Typescript
    vue-language-server # Vue
  ];
}
