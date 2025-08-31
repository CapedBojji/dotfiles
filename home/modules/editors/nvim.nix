{system, inputs, ...}: 

{
  home.packages = [
    inputs.nixcats.packages.${system}.nixCats
  ];
}