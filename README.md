Demonstrates basic TH failures with nixpkgs static infra.


```
$ nix build
> Building library for myprogram-0.1.0.0..
> [1 of 1] Compiling MyLib            ( src/MyLib.hs, dist/build/MyLib.o )
>
> <no location info>: error:
>     Couldn't find a target code interpreter. Try with -fexternal-interpreter
For full logs, run 'nix log /nix/store/55g99xl2vs7qs58mgxrxr4k138pa87sp-myprogram-static-x86_64-unknown-linux-musl-0.1.0.0.drv'.
```
