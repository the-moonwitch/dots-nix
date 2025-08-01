{ ... }:
{
  # TODO: Find a way to make this configurable?
  # options.flake.const.me = lib.mkOption {
  #   type = lib.types.submodule {
  #     options = {
  #       username = lib.mkOption {
  #         type = lib.types.str;
  #         default = "ines";
  #       };
  #       signature = lib.mkOption {
  #         type = lib.types.str;
  #         default = "ines";
  #       };
  #       email = lib.mkOption {
  #         type = lib.types.str;
  #         default = "ines@moonwit.ch";
  #       };
  #       authorizedKeys = lib.mkOption {
  #         type = lib.types.listOf lib.types.str;
  #         default = [ ];
  #       };
  #     };
  #   };
  # };

  flake.const.me = {
    username = "ines";
    signature = "ines";
    email = "ines@moonwit.ch";
  };
}
