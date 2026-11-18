namespace pipeline;

func stages() {
    return [
        ["name" => "lexer",             "status" => "done",    "impl" => "Workspace.lexer (Z#, parytet z Rust)"],
        ["name" => "parser + AST",      "status" => "stage0",  "impl" => "zsc0 check (Rust); wersja Z# do napisania"],
        ["name" => "semantic analysis", "status" => "todo",    "impl" => "-"],
        ["name" => "Z# IR (SSA)",       "status" => "todo",    "impl" => "-"],
        ["name" => "ZAMM lowering",     "status" => "todo",    "impl" => "-"],
        ["name" => "LLVM backend",      "status" => "todo",    "impl" => "-"],
        ["name" => "linker + runtime",  "status" => "todo",    "impl" => "-"],
        ["name" => "extern linking",    "status" => "todo",    "impl" => "składnia sparsowana w stage0; linkowanie w zsc"]
    ];
}
