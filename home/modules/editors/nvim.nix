{self, system, inputs, ...}: 

{
  home.packages = [
    # inputs.nixcats.packages.${system}.nixCats
  ];

  xdg.configFile."nvim".source = "${self}/parts/modules/home/editors/nvim";
}