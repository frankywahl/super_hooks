// Package git for interfacing with Git
package git

import (
	"bytes"
	"fmt"
	"os/exec"
	"strings"
)

// TopLevel returns a path to the root of your git directory
// It has an error if you are not currently in a Git repository
func TopLevel() (string, error) {
	cmd := exec.Command("git", "rev-parse", "--show-toplevel")
	errOut := &bytes.Buffer{}
	cmd.Stderr = errOut
	out, err := cmd.Output()
	if err != nil {
		return "", fmt.Errorf("%v", errOut.String())
	}
	return strings.TrimSpace(string(out[:])), nil
}

// HookPaths returns all the paths set for a given hook.
//
// It looks up the config of hooks.% to identify locations
func HookPaths() ([]string, error) {
	cmd := exec.Command("git", "config", "--get-all", "superhooks.path")
	out, err := cmd.Output()
	if err != nil {
		return []string{}, err
	}
	return strings.Split(strings.TrimSpace(string(out[:])), "\n"), nil
}
