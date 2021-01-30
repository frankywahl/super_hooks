package hook

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"

	"github.com/frankywahl/super_hooks/git"
)

// List contains a list of all known hooks
var List = []string{}

var paths = []string{}

func init() {
	paths = allPath()
	List = []string{
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
}

// For will return a list of executables for a given hook
func For(hookName string) []*exec.Cmd {
	var cmds []*exec.Cmd

	for _, location := range paths {
		path := filepath.Join(location, hookName)
		if _, err := os.Stat(path); err != nil {
			if os.IsNotExist(err) {
			} else {
				fmt.Println("Unhandled error")
			}
		} else {
			filepath.Walk(path, func(path string, f os.FileInfo, err error) error {
				if !f.IsDir() && isExecutable(f) {
					cmds = append(cmds, exec.Command(path))
				}
				return nil
			})
		}
	}
	return cmds
}

func isExecutable(f os.FileInfo) bool {
	return (f.Mode() & 0111) != 0
}

func allPath() []string {
	paths := []string{"global", "user", "local"}
	for i, p := range paths {
		if out, err := git.HookPath(p); err == nil {
			paths[i] = out
		}
	}
	return paths
}

func hasElement(list []string, word string) bool {
	for _, element := range list {
		if element == word {
			return true
		}
	}
	return false
}
