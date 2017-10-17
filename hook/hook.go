package hook

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"

	"github.com/frankywahl/super_hooks/git"
)

var list = map[string]Hook{}

func init() {
	paths := allPath()
	var localList = []string{
		"applypatch-msg",
		"commit-msg",
		"post-applypatch",
		"post-checkout",
		"post-commit",
		"post-merge",
		"post-receive",
		"pre-applypatch",
		"pre-auto-gc",
		"pre-commit",
		"pre-rebase",
		"pre-receive",
		"prepare-commit-msg",
		"update",
		"pre-push",
	}

	for _, hookName := range localList {
		list[hookName] = Hook{
			Name:            hookName,
			folderLocations: paths,
		}
	}
}

type Hook struct {
	Name            string
	folderLocations []string
}

// List will return a list of all hooks known to the system
func List() []Hook {
	var hook []Hook
	for _, hookValue := range list {
		hook = append(hook, hookValue)
	}
	return hook
}

// For will return Hook objects for a given hook type
func For(hookName string) (Hook, error) {
	hook, ok := list[hookName]
	if ok {
		return hook, nil
	} else {
		return Hook{}, fmt.Errorf("Could not find hooks for %s", hookName)
	}
}

// Executables will list out all executable runners for a given hook
func (h *Hook) Executables() []*exec.Cmd {
	var cmds []*exec.Cmd

	for _, location := range h.folderLocations {
		path := filepath.Join(location, h.Name)
		if _, err := os.Stat(path); err != nil {
			if os.IsNotExist(err) {
			} else {
				fmt.Println("Unhandled error")
			}
		} else {
			filepath.Walk(path, func(path string, f os.FileInfo, err error) error {
				if !f.IsDir() {
					cmds = append(cmds, exec.Command(path))
				}
				return nil
			})
		}
	}
	return cmds
}

func allPath() []string {
	paths := []string{}
	if out, err := git.GlobalHookPath(); err == nil {
		paths = append(paths, out)
	}

	if out, err := git.UserHookPath(); err == nil {
		paths = append(paths, out)
	}

	if out, err := git.LocalHookPath(); err == nil {
		paths = append(paths, out)
	}

	return paths
}
