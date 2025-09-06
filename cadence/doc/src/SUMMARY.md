# Summary

- [Introduction](../../README.md)
- [Usage](./00_usage.md)
- [API](./10_api.md)

# TODO: Note: confusing error on `nixosFeature module` rather than `nixosFeature.system module`:

```

error:
       … while checking flake output 'nixosConfigurations'

       … while checking the NixOS configuration 'nixosConfigurations.moth'

       … while calling the 'seq' builtin
         at /nix/store/5rpy1yfkb7mxfnqv5gl528irddj0zyzx-source/lib/modules.nix:361:18:
          360|         options = checked options;
          361|         config = checked (removeAttrs config [ "_module" ]);
             |                  ^
          362|         _module = checked (config._module);

       (stack trace truncated; use '--show-trace' to show the full trace)

       error: function 'mkClassFeature' called with unexpected argument 'boot'
       at /nix/store/y095jj5w7g98sbbv2hd595hjk5r66qhb-source/modules/lib.nix:20:13:
           19|           mkClassFeature =
           20|             {
             |             ^
           21|               system ? { },
```
