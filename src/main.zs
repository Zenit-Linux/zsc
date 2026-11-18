#( zsc — kompilator AOT Z# (repo: zsc)

   STAN: frontend. `check` i `--tokens` działają (lekser Z#, parser przez stage0).
   `build` wymaga backendu LLVM (Z# IR -> LLVM IR), którego jeszcze nie ma —
   kończy się kodem 3 z czytelnym komunikatem zamiast udawać kompilację. )#

import Workspace.lexer;
import Workspace.cli;
import pipeline;

func usage(): void {
    println("użycie:");
    println("  zsc check <plik.zs>                 sprawdź składnię");
    println("  zsc build <plik.zs> [-o <wyjście>] [--release|--debug] [--target <triple>] [-O0..-O3|-Os]");
    println("  zsc --tokens <plik.zs>              zrzut tokenów");
    println("  zsc stages                          stan etapów kompilatora");
}

func stage0(): string { return System.env("ZSC0") ?? "zsc0"; }

func lexCheck(string $file): int {
    try { lexer.tokenize(File.read($file)); }
    catch (Exception $e) { eprintln($file . ": " . $e->getMessage()); return 1; }
    return 0;
}

func check(string $file): int {
    if (!File.exists($file)) { eprintln("zsc: nie znaleziono pliku " . $file); return 1; }
    if (lexCheck($file) !== 0) { return 1; }
    $r = Process.run(stage0(), ["check", $file]);
    if ($r["status"] !== 0) { eprintln(trim($r["stderr"])); return 1; }
    return 0;
}

func build(string $file, $opts): int {
    if (check($file) !== 0) { return 1; }
    $target = $opts["options"]["target"] ?? "host";
    eprintln("zsc: składnia poprawna, ale backend LLVM nie jest jeszcze zaimplementowany");
    eprintln("zsc: (cel: " . $target . ") — zob. `zsc stages`. Do uruchamiania użyj `zsi " . $file . "`.");
    return 3;
}

func main(): int {
    $r = cli.parse(System.args(), ["o", "target"]);
    $pos = $r["positional"];
    $flags = $r["flags"];
    if (has_key($flags, "--tokens") && count($pos) === 1) {
        foreach (lexer.tokenize(File.read($pos[0])) as $t) { println($t["line"] . ":" . $t["col"] . "\t" . $t["kind"] . "\t" . $t["text"]); }
        return 0;
    }
    if (count($pos) === 0) { usage(); return 2; }
    $cmd = $pos[0];
    if ($cmd === "stages") {
        foreach (pipeline.stages() as $s) { println(pad_right($s["name"], 20) . pad_right($s["status"], 8) . $s["impl"]); }
        return 0;
    }
    if (count($pos) < 2) { usage(); return 2; }
    if ($cmd === "check") { return check($pos[1]); }
    if ($cmd === "build") { return build($pos[1], $r); }
    eprintln("zsc: nieznane polecenie " . $cmd);
    usage();
    return 2;
}

exit(main());
