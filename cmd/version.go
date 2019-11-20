package cmd

import (
	"fmt"
	"time"

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
		fmt.Printf("Version:    %s\nRevision:   %s\nCreated at: %s\n",
			version.Version, version.GitRevision, time.Now().UTC().Format(time.RFC3339))
		return nil
	},
}

func init() {
	rootCmd.AddCommand(versionCmd)
}
