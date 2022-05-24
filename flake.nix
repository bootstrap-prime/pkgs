{
  description = "qmp3gain";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";

  outputs = { self, nixpkgs }: let
    pkgs = (import nixpkgs {
      system = "x86_64-linux";
    });
  in {
    packages.x86_64-linux.qmp3gain = pkgs.appimageTools.wrapType2  {
      name = "qmp3gain";
      # version = "0.9.2";

      src = pkgs.fetchurl {
        url = "mirror://sourceforge/qmp3gain/0.9.2/qmp3gain-0.9.2-linux-x64.AppImage";
        sha256 = "sha256-Gl+4DY35cabMg/LYIb/Qv0DVbkj1wPI9lM2PtJTslGw=";
      };

      extraPkgs = pkgs: with pkgs; [ aacgain vorbisgain mp3gain ];
    };

    packages.x86_64-linux.easyeffects = pkgs.easyeffects.overrideAttrs (old: rec {
      version = "2022-05-23";
      src = pkgs.fetchFromGitHub {
        owner = "wwmm";
        repo = "easyeffects";
        rev = "4ffd8b0ef0b9d2991b343de217992679cb23e0db";
        sha256 = "GO2IPsFjS2DcyFt3+ebKps+hl7R94l51Pog8q1MbqHI=";
      };
      buildInputs = with pkgs; [
        libadwaita
        cmake
        (pkgs.stdenv.mkDerivation rec {
          pname = "tbb";
          version = "2021.5.0";
          src = pkgs.fetchFromGitHub {
            owner = "oneapi-src";
            repo = "oneTBB";
            rev = "v${version}";
            sha256 = "TJ/oSSMvgtKuz7PVyIoFEbBW6EZz7t2wr/kP093HF/w=";
            fetchSubmodules = true;
          };
          buildInputs = [ cmake ];
        })
        (pkgs.fmt.overrideAttrs (old: rec {
          version = "8.1.1";
          src = pkgs.fetchFromGitHub {
            owner = "fmtlib";
            repo = "fmt";
            rev = "${version}";
            sha256 = "leb2800CwdZMJRWF5b1Y9ocK0jXpOX/nwo95icDf308=";
            fetchSubmodules = true;
          };
        }))
      ] ++ old.buildInputs;
    });

  };
}
