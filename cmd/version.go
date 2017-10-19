package cmd

import (
	"fmt"

	"github.com/frankywahl/super_hooks/version"
	"github.com/spf13/cobra"
)

var versionCmd = &cobra.Command{
	Use:     "version",
	Short:   "Print out super_hooks version information",
	Long:    "Get the current version of super_hooks",
	Args:    cobra.NoArgs,
	Aliases: []string{"v"},
	RunE: func(cmd *cobra.Command, args []string) error {
		fmt.Printf("Version: %s\nRevision: %s\n", version.Version, version.GitRevision)
		return nil
	},
}

func init() {
	RootCmd.AddCommand(versionCmd)
}
