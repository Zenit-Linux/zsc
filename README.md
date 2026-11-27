# zsc — kompilator Z# (backend LLVM >= 21)

`zsc` to niezależny backend: **Z# → AST → sema → IR → LLVM IR → `opt` → `llc` → linker**. Nie transpiluje do C i nie woła kompilatora C dla
kodu programu. Jedyny kod C na drodze to wspólny runtime (`Z-Sharp/runtime/native/zs_rt.c`), kompilowany raz do cache
(`~/.cache/zsc`) lub dostarczany gotowy (`--runtime-obj`).

```
zsc build prog.zs                    # plik wykonywalny ./prog
zsc build prog.zs --emit ll|bc|asm|obj|ir|zbc -o wyjście
zsc build prog.zs -O3 --target aarch64-linux-gnu   # (skrośnie: niezweryfikowane)
zsc run prog.zs -- argumenty         # zbuduj i uruchom; kod wyjścia programu = kod wyjścia zsc
zsc check [--strict] [--native] prog.zs
zsc analyze prog.zs                  # klasy pamięci ZAMM
zsc toolchain                        # wykryte opt/llc/clang i ich wersje
zsc runtime [-o zs_rt.o]             # zbuduj obiekt runtime
```

Wymagania: **LLVM >= 21** (`opt`, `llc`, `clang` jako sterownik linkera). Wyszukiwanie: `--llvm-bin`, `ZS_LLVM_BIN`, `opt-21`/`opt` w `PATH`,
`/usr/lib/llvm-21/bin`. Za stara wersja → kod wyjścia 3 i komunikat; `--allow-older-llvm` (lub `ZS_ALLOW_OLD_LLVM=1`) obniża próg do 17 bez gwarancji.

Opcje toolchaina: `--linker <sterownik>` (`ZS_LINKER`), `--runtime-obj <plik.o>` (`ZS_RUNTIME_OBJ`), `--ldflags "..."`, `--keep-temps`.
Kody wyjścia: 0 ok · 1 błąd (składnia, konstrukcja spoza podzbioru natywnego, błąd narzędzia) · 2 użycie · 3 brak/za stary LLVM.

Bootstrap i zależności: `Z-Sharp/docs/BOOTSTRAP.md`. Testy: `tests/run.sh`.
Stan zweryfikowany: Linux x86-64, LLVM 21.1.8. Inne platformy i kompilacja skrośna — niesprawdzone.
