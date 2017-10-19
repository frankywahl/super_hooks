package cmd

import (
	"fmt"
	"os"
	"path"

	"github.com/spf13/cobra"
)

// RootCmd represents the base command when called without any subcommands
var RootCmd = &cobra.Command{
	Use:   "super_hooks",
	Short: "Tool for managing git-hooks",
	Long: `
	Tool that changes the git-hooks so that you can share hooks across mulitple git 
	directories. You include hooks in folder so that each executable can be in charge 
	of only one thing (preserving the SRP rule in your hooks too)`,
	RunE: func(cmd *cobra.Command, args []string) error {
		file, err := os.Executable()
		if err != nil {
			return err
		}

		fileName := path.Base(file)
		if fileName == "super_hooks" {
			return listCmd.RunE(cmd, []string{})
		} else {
			return runCmd.RunE(cmd, []string{fileName})
		}
	},
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	if err := RootCmd.Execute(); err != nil {
		fmt.Printf("Error: %s\n\n", err)
		os.Exit(-1)
	}
}

// Verbose allows commands to get more output
var Verbose bool

func init() {
	RootCmd.PersistentFlags().BoolVarP(&Verbose, "verbose", "v", false, "verbose output")
}
