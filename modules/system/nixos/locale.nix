{ lib, ... }:
{
  flake.aspects."system/nixos/locale".nixos = {
    services.xserver.xkb = {
      layout = lib.mkDefault "pl";
      variant = lib.mkDefault "";
    };
    console.useXkbConfig = lib.mkDefault true;

    time.timeZone = lib.mkDefault "Europe/Warsaw";
    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

    # https://codeberg.org/fugi/nix-config/src/commit/059f74a5a49d7f47d3b484d233cdf191becf4055/modules/locale.nix
    # i18n.glibcLocales = ...;
    i18n.extraLocaleSettings = {
      # Regional settings
      # -----------------
      # No idea if this or en_US is better or if it even matters.
      LC_IDENTIFICATION = lib.mkDefault "en_US.UTF-8";
      LC_CTYPE = lib.mkDefault "pl_PL.UTF-8";
      LC_COLLATE = lib.mkDefault "pl_PL.UTF-8";
      LC_ADDRESS = lib.mkDefault "pl_PL.UTF-8";
      LC_TELEPHONE = lib.mkDefault "pl_PL.UTF-8";

      # English-speaking preference
      # ---------------------------
      LANG = lib.mkDefault "en_US.UTF-8";
      LANGUAGE = lib.mkDefault "en";
      LC_MESSAGES = lib.mkDefault "en_US.UTF-8"; # Y/N forms

      # ISO standards
      # -------------
      LC_TIME = lib.mkDefault "en_DK.UTF-8"; # ISO-8601 with English names
      LC_PAPER = lib.mkDefault "pl_PL.UTF-8"; # ISO-216
      LC_MEASUREMENT = lib.mkDefault "pl_PL.UTF-8"; # ISO/IEC-80000

      # Opinionated specifics
      # ---------------------
      LC_NAME = lib.mkDefault "pl_PL.UTF-8"; # No honorifics
      # Dot as decimal separator.
      # TODO: Patch with space as thousands separator.
      LC_NUMERIC = lib.mkDefault "en_US.UTF-8";
      # PLN.
      # TODO: Patch with dot as decimal separator.
      LC_MONETARY = lib.mkDefault "pl_PL.UTF-8";
    };
  };
}
