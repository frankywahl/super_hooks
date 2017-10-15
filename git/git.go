// Package for interfacing with Git
package git

import (
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
	} else {
		return strings.TrimSpace(string(out[:])), nil
	}
}

// GlobalHookPath hooks path
func GlobalHookPath() (string, error) {
	cmd := exec.Command("git", "config", "hooks.global")
	out, err := cmd.Output()
	if err != nil {
		return "", err
	} else {
		return strings.TrimSpace(string(out[:])), nil
	}
}

// UserHookPath hooks path
func UserHookPath() (string, error) {
	cmd := exec.Command("git", "config", "hooks.user")
	out, err := cmd.Output()
	if err != nil {
		return "", err
	} else {
		return strings.TrimSpace(string(out[:])), nil
	}
}

// GlobalHookPath hooks path
func LocalHookPath() (string, error) {
	cmd := exec.Command("git", "config", "hooks.local")
	out, err := cmd.Output()
	if err != nil {
		return "", err
	} else {
		return strings.TrimSpace(string(out[:])), nil
	}
}