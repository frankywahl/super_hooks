package hook_test

import (
	"testing"

	"github.com/frankywahl/super_hooks/hook"
)

func TestList(t *testing.T) {
	hooks := []string{
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

	for _, h := range hooks {
		if !hasElement(hook.List, h) {
			t.Errorf("Error expected to have a hook for %+v", h)
		}
	}
}

func hasElement(list []string, word string) bool {
	for _, element := range list {
		if element == word {
			return true
		}
	}
	return false
}
