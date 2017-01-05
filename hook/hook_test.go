package hook

import (
	"testing"
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

	list := List()

	for _, hookName := range hooks {
		if !contains(list, hookName) {
			t.Errorf("Error expected to have a hook for %+v", hookName)
		}
	}

	if len(list) != len(hooks) {
		t.Errorf("Missing a hook, got %+v hooks, want %+v hooks", len(list), len(hooks))
	}
}

func TestFor(t *testing.T) {
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
	for _, hookName := range hooks {
		hook, err := For(hookName)

		if err != nil {
			t.Errorf("Error %s", err)
		}

		if hook.Name != hookName {
			t.Errorf("Error got: %+v, want %+v", hook.Name, hookName)
		}

	}

	_, err := For("non-existent")
	if err == nil {
		t.Errorf("Expected to fail")
	}
}

func contains(hooks []Hook, hookName string) bool {
	for _, hook := range hooks {
		if hook.Name == hookName {
			return true
		}
	}
	return false
}
