  {
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";


    # https://github.com/cachix/devenv/issues/756#issuecomment-1684049113
    devenv.url = "github:cachix/devenv/9ba9e3b908a12ddc6c43f88c52f2bf3c1d1e82c1";
    #devenv.url = "github:cachix/devenv";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, ... } @ inputs:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
    in
    {
      devShell.x86_64-linux = devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          ({ pkgs, ... }: {
            packages = [ pkgs.hello pkgs.process-compose ];
            processes = 
            {
              foo.exec = ''
                  sleep 5
                  echo foo
                '';
              bar = {
                exec = ''
                    sleep 5
                    echo bar
                  '';
                process-compose.depends_on.foo.condition = "process_completed_successfully";
              };
            };

            enterShell = ''
              hello
            '';

          })
        ];
      };
    };
}
