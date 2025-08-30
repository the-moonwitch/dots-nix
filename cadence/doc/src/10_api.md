```nim
feature :: {
    extra :: { <name> :: anything } = {};
    <name> :: featureImpl;
};

featureImpl :: {
    pred :: hostKey -> bool = lib.const true;
    nixos :: deferredModule = {};
    darwin :: deferredModule = {};
    home :: deferredModule = {};
};

host :: {
    hostname :: string;
    system :: enum inputs.nix-systems;
    class :: enum [ "nixos" "darwin" "home" ];
    features :: [ string ];
    username :: string;
    extra :: { <name> :: anything } = {};
}

flake.hosts :: { <name> :: host } = {};
flake.features :: { <name> :: feature } = {};
flake.dependencies :: { <name> :: [ string ] } = {};
```
