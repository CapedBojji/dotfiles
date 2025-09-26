{ ... }:
{
  # Shared, reusable devenv scripts for all shells
  # Usage: chat [args...] -> forwards to VS Code Chat with -r @args
  scripts.chat.exec = "code chat -r @args";
}
