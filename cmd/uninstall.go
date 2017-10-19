package cmd

import (
	"errors"
	"fmt"
	"os"
	"path/filepath"

	"github.com/frankywahl/super_hooks/git"
	"github.com/spf13/cobra"
)

var uninstallCmd = &cobra.Command{
	Use:   "uninstall",
	Short: "Uninstalls super_hooks from this repository",
	Long: `
	Replaces .git/hooks/ folder with .git/hooks.back/ folder
	thereby removing the use of super_hooks
	`,
	Args: cobra.NoArgs,
	RunE: func(cmd *cobra.Command, args []string) error {
		if folder, err := git.TopLevel(); err != nil {
			panic(err)
		} else {
			originalDir := filepath.Join(folder, ".git", "hooks")
			destinationDir := filepath.Join(folder, ".git", "hooks.back")
			directoryExists, _ := exists(destinationDir)
			if !directoryExists {
				return errors.New("Super hooks is not installed")
			} else {
				if err := os.RemoveAll(originalDir); err != nil {
					panic(err)
				}
				if err := os.Rename(destinationDir, originalDir); err != nil {
					fmt.Println(err)
				}
			}
		}
		fmt.Println("Super Hooks uninstalled successfully")
		return nil
	},
}

func init() {
	RootCmd.AddCommand(uninstallCmd)
}
