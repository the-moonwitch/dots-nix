{ lib, ... }:
let
  mcpServers = [
    "@modelcontextprotocol/server-filesystem"
    "@modelcontextprotocol/server-memory"
    "@modelcontextprotocol/server-sequential-thinking"
    "@modelcontextprotocol/server-fetch"
    "@modelcontextprotocol/server-github"
    "@upstash/context7-mcp"
  ];
in
{
  flake.aspects.mcp-servers.homeManager = { config, pkgs, ... }: {
    home.packages = with pkgs; [ nodejs ];

    home.activation.installMcpServers = config.lib.dag.entryAfter ["writeBoundary"] ''
      PATH="${pkgs.nodejs}/bin:$PATH"

      $DRY_RUN_CMD npx -y ${lib.concatStringsSep " " mcpServers} > /dev/null 2>&1 || true
    '';
  };
}
