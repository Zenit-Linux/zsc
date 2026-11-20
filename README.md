# zsc — kompilator AOT Z# (0.0.1)

`zsc` jest napisany w Z# i korzysta z rdzenia `Z-Sharp` (lexer, parser, sema, IR, backendy C i LLVM).

```
zsc build prog.zs                  # binarka natywna: AST → sema → IR → C → cc + runtime/native/zs_rt.c
zsc build prog.zs --backend llvm   # AST → sema → IR → LLVM IR → clang (+ --target <triple>, --emit ll)
zsc build prog.zs -o app -O3       # nazwa i poziom optymalizacji
zsc build prog.zs --emit c         # tylko kod C   (--emit ir | zbc | exe)
zsc run prog.zs -- arg1 arg2       # zbuduj i uruchom (kod wyjścia programu = kod wyjścia zsc)
zsc check [--strict] [--native] prog.zs
zsc analyze prog.zs                # analiza ucieczki: klasy pamięci ZAMM
zsc stages | --tokens | --version
```

Kody wyjścia: `0` ok, `1` błąd (składnia, konstrukcja spoza podzbioru, brak toolchaina), `2` użycie, `3` cel niedostępny (`--target` ≠ `host` bez `--backend llvm`).
Zmienne: `ZS_HOME` (katalog Z-Sharp), `ZS_CC` / `--cc` (kompilator C; dla LLVM: clang).

## Wymagania
Zbudowany rdzeń (`cd Z-Sharp && cargo build --release`) oraz kompilator C (`cc`/`gcc`/`clang`; backend LLVM wymaga `clang`). Repo `Z-Sharp` dołącz jako submoduł `Z-Sharp/`.
Uruchamianie samego `zsc`: `Z-Sharp/target/release/zsc0 run src/main.zsharp <polecenie>` (albo jako `.zbc`: `zsc0 exec zsc.zbc <polecenie>`).

## Podzbiór języka w backendzie natywnym
Obsługiwane: funkcje (domyślne parametry, rekurencja, kontrakty typów int/float/string/bool/array), `int`/`float`/`bool`/`null`/napisy, tablice indeksowane i asocjacyjne
(klucze int/string, semantyka wartości, `$a[] = x`, zagnieżdżone, `keys/values/has_key`), `if/elseif/else`, `while`, `do-while`, `for`, `foreach`, `switch`, `try/catch/finally/throw` (`Exception`, `Error`, `Throwable`, `getMessage`), `break/continue N`, `??`, `?:`,
operatory arytmetyczne i porównania, `echo/necho/eecho/exit`, wbudowane (`count`, `strlen`, `substr`, `trim`, `join`, `range`, `in_array`, `Math.*`, …).
Poza podzbiorem (błąd `E0101…E0107` z linią): klasy i własne klasy wyjątków, domknięcia, importy modułów Z#, argumenty nazwane/variadic, operatory bitowe. Wyszukiwanie klucza w tablicach asocjacyjnych jest liniowe (O(n)).
Semantyka (stdout, stderr, kod wyjścia, komunikaty błędów, numery linii) jest sprawdzana testami różnicowymi względem interpretera dla obu backendów: `tests/native/run_diff.sh` (12/12).

## Ograniczenia
Pamięć natywna: czas życia `Persistent` (bez zwalniania do końca procesu); obniżanie do ramek ZAMM wg analizy ucieczki — do zrobienia. SSA, domknięcia, named args, statyczne pola i `extern` — do zrobienia. Klasy, wyjątki-klasy, moduły (`import`), wariadyki i operatory bitowe działają natywnie; `zsc` kompiluje samego siebie natywnie (`Z-Sharp/scripts/stage3.sh`).
