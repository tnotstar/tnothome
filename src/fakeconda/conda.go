package main

import (
	"fmt"
	"os"
	"os/exec"
)

func main() {
	// Call `micromamba` with the provided command arguments
	output, err := exec.Command("micromamba", os.Args[1:]...).Output()
	if err != nil {
		fmt.Println("Error executing `micromamba` command:", err)
		os.Exit(1)
	}
	fmt.Println(string(output))
}
