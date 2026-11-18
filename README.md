# zsc — kompilator AOT Z#
Stan: frontend w Z# (lekser + parser z `Z-Sharp`, stage1). `check`, `--tokens`, `stages` działają. `build` kończy się kodem 3 (brak backendu LLVM) — nie udaje kompilacji.
Manifest: `Z#.toml` (zależność `Z-Sharp` przez `path`/`git`; dodaj jako submoduł `Z-Sharp/`).
Kolejne kroki: analiza semantyczna, Z# IR, ZAMM lowering (`zamm::Hint`), LLVM, linkowanie `extern`, link `libzs_runtime.a` (`Z-Sharp/runtime`).
