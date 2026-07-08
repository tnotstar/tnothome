package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"syscall"
	"unsafe"

	"github.com/pelletier/go-toml/v2"
	"golang.org/x/sys/windows"
	"golang.org/x/sys/windows/registry"
)

// Feature maps each section of the TOML configuration file
type Feature struct {
	Path   string `toml:"path"`
	Type   string `toml:"type,omitempty"`
	Value  string `toml:"value,omitempty"`
	Delete bool   `toml:"delete,omitempty"`
}

var (
	user32          = windows.NewLazySystemDLL("user32.dll")
	procMessageBoxW = user32.NewProc("MessageBoxW")
)

const (
	MB_YESNO    = 0x00000004
	MB_ICONINFO = 0x00000040
	IDYES       = 6
)

func main() {
	var runSilent, runAdmin bool
	flag.BoolVar(&runSilent, "Silent", false, "Run without prompts")
	flag.BoolVar(&runAdmin, "RunAs", false, "Internal flag for elevated execution")
	flag.Parse()

	// 1. Load the configuration file (.toml)
	exePath, err := os.Executable()
	if err != nil {
		log.Fatalf("Error obtaining executable path: %v", err)
	}
	baseDir := filepath.Dir(exePath)
	configPath := filepath.Join(baseDir, "fuckthem.toml")

	data, err := os.ReadFile(configPath)
	if err != nil {
		showMessage("Fuck Them All!", fmt.Sprintf("Failed to read config: %v", err), runSilent, MB_ICONINFO)
		os.Exit(-1)
	}

	var config map[string]Feature
	if err := toml.Unmarshal(data, &config); err != nil {
		showMessage("Fuck Them All!", fmt.Sprintf("Error parsing TOML: %v", err), runSilent, MB_ICONINFO)
		os.Exit(-1)
	}

	// 2. Verify which changes are required
	todo := make(map[string]Feature)
	issues := 0

	for name, feature := range config {
		if !verifyIt(feature) {
			todo[name] = feature
			issues++
		}
	}

	if issues == 0 {
		os.Exit(0) // Everything is in order
	}

	// 3. Confirm execution
	letsGo := runAdmin || runSilent
	if !letsGo {
		msg := fmt.Sprintf("There are %d wrong features. Could I fuck all them up?", issues)
		response := showMessage("Fuck Them All!", msg, runSilent, MB_YESNO|MB_ICONINFO)
		letsGo = (response == IDYES)
	}

	if !letsGo {
		os.Exit(0)
	}

	// 4. Verify privilege elevation and relaunch if necessary
	if !isRunningElevated() {
		err := runElevated(runSilent)
		if err != nil {
			showMessage("Fuck Them All!", fmt.Sprintf("Error elevating privileges: %v", err), runSilent, MB_ICONINFO)
			os.Exit(-1)
		}
		os.Exit(0)
	}

	// 5. Apply changes to the registry
	for name, feature := range todo {
		if err := fuckIt(feature); err != nil {
			showMessage("Fuck Them All!", fmt.Sprintf("Error applying '%s': %v", name, err), runSilent, MB_ICONINFO)
			os.Exit(-1)
		}
	}

	// Update system parameters
	exec.Command("rundll32.exe", "user32.dll,", "UpdatePerUserSystemParameters").Run()

	// 6. Restart Explorer
	restartShell := runAdmin || runSilent
	if !restartShell {
		response := showMessage("Fuck Them All!", "Bad features have been fucked them all! Restart the shell?", runSilent, MB_YESNO|MB_ICONINFO)
		restartShell = (response == IDYES)
	}

	if restartShell {
		exec.Command("taskkill.exe", "/F", "/IM", "explorer.exe").Run()
		exec.Command("explorer.exe").Start()
	}
}

// --- Helper Functions ---

func parseRegistryPath(fullPath string) (registry.Key, string, string, error) {
	parts := strings.SplitN(fullPath, `\`, 2)
	if len(parts) != 2 {
		return 0, "", "", fmt.Errorf("invalid path")
	}

	var root registry.Key
	switch strings.ToUpper(parts[0]) {
	case "HKLM":
		root = registry.LOCAL_MACHINE
	case "HKCU":
		root = registry.CURRENT_USER
	default:
		return 0, "", "", fmt.Errorf("unknown root key: %s", parts[0])
	}

	lastSlash := strings.LastIndex(parts[1], `\`)
	if lastSlash == -1 {
		return root, parts[1], "", nil
	}
	keyPath := parts[1][:lastSlash]
	valueName := parts[1][lastSlash+1:]

	// If it ends with a backslash, the key is the entire path and the value is the default ("")
	if lastSlash == len(parts[1])-1 {
		keyPath = parts[1][:len(parts[1])-1]
		valueName = ""
	}

	return root, keyPath, valueName, nil
}

func verifyIt(f Feature) bool {
	root, keyPath, valueName, err := parseRegistryPath(f.Path)
	if err != nil {
		return false
	}

	k, err := registry.OpenKey(root, keyPath, registry.QUERY_VALUE)
	if err != nil {
		// If we intend to delete it and it does not exist, we are good
		return f.Delete
	}
	defer k.Close()

	if f.Delete {
		_, _, err := k.GetValue(valueName, nil)
		return err == registry.ErrNotExist
	}

	// Verify value based on type
	switch f.Type {
	case "REG_DWORD":
		val, _, err := k.GetIntegerValue(valueName)
		if err != nil {
			return false
		}
		expected, _ := strconv.ParseUint(f.Value, 10, 32)
		return val == expected
	case "REG_SZ":
		val, _, err := k.GetStringValue(valueName)
		if err != nil {
			return false
		}
		return val == f.Value
	}
	return false
}

func fuckIt(f Feature) error {
	root, keyPath, valueName, err := parseRegistryPath(f.Path)
	if err != nil {
		return err
	}

	var access uint32 = registry.SET_VALUE
	if f.Delete {
		access = registry.SET_VALUE | registry.QUERY_VALUE
	}

	// Attempt to create or open the key
	k, _, err := registry.CreateKey(root, keyPath, access)
	if err != nil {
		return err
	}
	defer k.Close()

	if f.Delete {
		err = k.DeleteValue(valueName)
		if err != nil && err != registry.ErrNotExist {
			return err
		}
		return nil
	}

	switch f.Type {
	case "REG_DWORD":
		val, _ := strconv.ParseUint(f.Value, 10, 32)
		return k.SetDWordValue(valueName, uint32(val))
	case "REG_SZ":
		return k.SetStringValue(valueName, f.Value)
	default:
		return fmt.Errorf("unsupported registry type: %s", f.Type)
	}
}

func isRunningElevated() bool {
	var sid *windows.SID
	err := windows.AllocateAndInitializeSid(
		&windows.SECURITY_NT_AUTHORITY, 2,
		windows.SECURITY_BUILTIN_DOMAIN_RID, windows.DOMAIN_ALIAS_RID_ADMINS,
		0, 0, 0, 0, 0, 0, &sid)
	if err != nil {
		return false
	}
	defer windows.FreeSid(sid)

	token := windows.Token(0)
	member, err := token.IsMember(sid)
	if err != nil {
		return false
	}
	return member
}

func runElevated(silent bool) error {
	exe, err := os.Executable()
	if err != nil {
		return err
	}

	args := "-RunAs"
	if silent {
		args += " -Silent"
	}

	verb, _ := syscall.UTF16PtrFromString("runas")
	exePtr, _ := syscall.UTF16PtrFromString(exe)
	argsPtr, _ := syscall.UTF16PtrFromString(args)
	cwdPtr, _ := syscall.UTF16PtrFromString(filepath.Dir(exe))

	return windows.ShellExecute(0, verb, exePtr, argsPtr, cwdPtr, windows.SW_NORMAL)
}

func showMessage(title, text string, silent bool, style uint32) int32 {
	if silent {
		return 0
	}
	tPtr, _ := syscall.UTF16PtrFromString(title)
	xPtr, _ := syscall.UTF16PtrFromString(text)
	ret, _, _ := procMessageBoxW.Call(0, uintptr(unsafe.Pointer(xPtr)), uintptr(unsafe.Pointer(tPtr)), uintptr(style))
	return int32(ret)
}
