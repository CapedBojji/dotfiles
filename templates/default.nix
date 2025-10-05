{ ... }:
{
  tauri = {
    path = ./rust/tauri;
    description = "Tauri application template";
  };
  rust-pure = {
    path = ./rust/pure;
    description = "Pure Rust project template (devenv shells: default, rust)";
  };
  roblox-jecs-luau = {
    path = ./roblox/jecs/luau;
    description = "JECS Luau project template (devenv shell: jecs-luau)";
  };
}