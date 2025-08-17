{
  flake.modules.nixos.locale = {
    services.xserver.xkb = {
      layout = "pl";
      variant = "";
    };
    console.useXkbConfig = true;

    time.timeZone = "Europe/Warsaw";
    i18n.defaultLocale = "en_US.UTF-8";

    # https://codeberg.org/fugi/nix-config/src/commit/059f74a5a49d7f47d3b484d233cdf191becf4055/modules/locale.nix
    # i18n.glibcLocales = ...;
    i18n.extraLocaleSettings = {
      # Regional settings
      # -----------------
      # No idea if this or en_US is better or if it even matters.
      LC_IDENTIFICATION = "pl_PL.UTF-8";
      LC_CTYPE = "pl_PL.UTF-8";
      LC_COLLATE = "pl_PL.UTF-8";
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";

      # English-speaking preference
      # ---------------------------
      LANG = "en_US.UTF-8";
      LANGUAGE = "en:pl";
      LC_MESSAGES = "en_US.UTF-8"; # Y/N forms

      # ISO standards
      # -------------
      LC_TIME = "en_DK.UTF-8"; # ISO-8601 with English names
      LC_PAPER = "pl_PL.UTF-8"; # ISO-216
      LC_MEASUREMENT = "pl_PL.UTF-8"; # ISO/IEC-80000

      # Opinionated specifics
      # ---------------------
      LC_NAME = "pl_PL.UTF-8"; # No honorifics
      # Dot as decimal separator.
      # TODO: Patch with space as thousands separator.
      LC_NUMERIC = "en_US.UTF-8";
      # PLN.
      # TODO: Patch with dot as decimal separator.
      LC_MONETARY = "pl_PL.UTF-8";
    };
  };
}
