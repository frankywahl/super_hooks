package cmd

import (
	"errors"
	"fmt"
	"html/template"
	"os"
	"path/filepath"

	"github.com/frankywahl/super_hooks/git"
	"github.com/frankywahl/super_hooks/hook"
	"github.com/spf13/cobra"
)

var installCmd = &cobra.Command{
	Use:   "install",
	Short: "Installs super_hooks in this repository",
	Long: `
	Install super_hooks in the current directory. 
	This changes the content of your .git/hooks folder
	and make a backup of it into git/hooks.back
	`,
	Args: cobra.NoArgs,
	RunE: func(cmd *cobra.Command, args []string) error {
		if folder, err := git.TopLevel(); err != nil {
			panic(err)
		} else {
			originalDir := filepath.Join(folder, ".git", "hooks")
			destinationDir := filepath.Join(folder, ".git", "hooks.back")
			directoryExists, _ := exists(destinationDir)
			if directoryExists {
				return errors.New("SuperHooks already installed")
			} else {
				if err := os.Rename(originalDir, destinationDir); err != nil {
					return err
				}
				if err := os.Mkdir(originalDir, os.ModePerm); err != nil {
					return err
				}

				temp := `#!/usr/bin/env bash
if command -v super_hooks &>/dev/null; then
	super_hooks run {{.FileName}} $@
else
	echo "super_hooks not found"
	exit 1
fi
`
				for _, hookName := range hook.List {
					data := struct {
						FileName string
					}{hookName}

					tmpl, err := template.New("Anything").Parse(temp)
					if err != nil {
						panic(err)
					}

					fileName := filepath.Join(originalDir, hookName)
					file, err := os.Create(fileName)
					if err != nil {
						panic(err)
					}
					defer file.Close()
					file.Chmod(0755)

					err = tmpl.Execute(file, data)
				}
				fmt.Println("Super Hooks installed successfully")
				return nil
			}
		}
	},
}

func init() {
	RootCmd.AddCommand(installCmd)
}

// exists returns whether the given file or directory exists or not
func exists(path string) (bool, error) {
	_, err := os.Stat(path)
	if err == nil {
		return true, nil
	}
	if os.IsNotExist(err) {
		return false, nil
	}
	return true, err
}
