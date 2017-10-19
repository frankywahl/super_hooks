package main

import (
	"github.com/frankywahl/super_hooks/cmd"
)

func main() {
	// if _, file, no, ok := runtime.Caller(0); ok {
	// 	fmt.Printf("HERE: File: %s, Line: %d\n", file, no)
	// }
	cmd.Execute()
}
