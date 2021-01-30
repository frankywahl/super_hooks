// Package git for interfacing with Git
package git

import (
	"fmt"
	"os/exec"
	"strings"
)

// IsGitRepository return true if the working repository
// has been initialized as a working repository
func IsGitRepository() bool {
	cmd := exec.Command("git", "rev-parse", "--show-toplevel")
	if err := cmd.Run(); err != nil {
		return false
	}
	return true
}

// TopLevel returns a path to the root of your git directory
// It has an error if you are not currently in a Git repository
func TopLevel() (string, error) {
	cmd := exec.Command("git", "rev-parse", "--show-toplevel")
	out, err := cmd.Output()
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(out[:])), nil
}

// HookPath gives us a hook path
func HookPath(p string) ([]string, error) {
	cmd := exec.Command("git", "config", fmt.Sprintf("hooks.%s", p))
	out, err := cmd.Output()
	if err != nil {
		return []string{}, err
	}
	return strings.Split(strings.TrimSpace(string(out[:])), "\n"), nil
}
