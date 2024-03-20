@rem Copyright 2024, Antonio Alvarado Hernández <tnotstar@gmail.com>

@setlocal enableextensions
@setlocal disabledelayedexpansion

@echo Info: Installing Gopass git credential helper...
@go install "github.com/gopasspw/git-credential-gopass@latest"

@echo Info: Installing Go language server...
@go install "golang.org/x/tools/gopls@latest"

@echo Info: Installing Delve debugger...
@go install "github.com/go-delve/delve/cmd/dlv@latest"

@echo Info: Installing ApiSprout mock server...
@go install "github.com/danielgtaylor/apisprout@latest"

@goto :eof

@endlocal

:eof
