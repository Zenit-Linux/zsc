# zsc — kompilator AOT Z#
Stan: frontend. `check`, `--tokens`, `stages` działają. `build` kończy się kodem 3 (brak backendu LLVM) — nie udaje kompilacji.
Kolejne kroki: parser w Z#, analiza semantyczna, Z# IR, ZAMM, LLVM, linkowanie `extern` (`zsc stages`).
