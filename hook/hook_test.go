package hook_test

import (
	"slices"
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
		if !slices.Contains(hook.List, h) {
			t.Errorf("Error expected to have a hook for %+v", h)
		}
	}
}
