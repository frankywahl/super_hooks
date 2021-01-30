package main

import (
	"fmt"
	"os"

	"github.com/frankywahl/super_hooks/cmd"
)

func main() {
	superHooks := cmd.SuperHooks()
	err := superHooks.Execute()
	if err != nil {
		fmt.Printf("Error: %s\n\n", err)
		os.Exit(-1)
	}
}
