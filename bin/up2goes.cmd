@rem Copyright 2024, Antonio Alvarado Hernández <tnotstar@gmail.com>

@setlocal enableextensions
@setlocal disabledelayedexpansion

@echo Info: Installing Delve debugger...
@go install "github.com/go-delve/delve/cmd/dlv@latest"

@echo Info: Installing Go language server...
@go install "golang.org/x/tools/gopls@latest"

@echo Info: Installing Go Staticcheck linter...
@go install "honnef.co/go/tools/cmd/staticcheck@latest"

@echo Info: Installing Go Tags modifier...
@go install "github.com/fatih/gomodifytags@latest"

@echo Info: Installing Go Tests generator...
@go install "github.com/cweill/gotests/gotests@latest"

@echo Info: Installing Simple Project Scaffolder for Go...
@go install "github.com/vg006/vgo@latest"

@echo Info: Installing Go Blueprint generator...
@go install "github.com/melkeydev/go-blueprint@latest"

@echo Info: Installing Go Implementation Stubs generator...
@go install "github.com/josharian/impl@latest"

@echo Info: Installing Elvish shell...
@go install "src.elv.sh/cmd/elvish@latest"

@echo Info: Installing Gopass password manager...
@go install "github.com/gopasspw/gopass@latest" 

@echo Info: Installing Gopass git credential helper...
@go install "github.com/gopasspw/git-credential-gopass@latest"

@echo Info: Installing ApiSprout mock server...
@go install "github.com/danielgtaylor/apisprout@latest"

@echo Info: Installing Note utility...
@go install "github.com/armand-sauzay/note@latest"

@echo Info: Installing Go Play client...
@go install "github.com/haya14busa/goplay/cmd/goplay@latest"

@goto :eof
@endlocal

:eof
