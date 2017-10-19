package cmd

import (
	"os"

	"github.com/frankywahl/super_hooks/hook"
	"github.com/spf13/cobra"
)

var runCmd = &cobra.Command{
	Use:   "run",
	Short: "Run a specific hooks",
	Long: `
	Allows to simulate the running of a sepecific hook
	without having to invoke git
	`,
	Aliases: []string{"r"},
	Args:    cobra.MinimumNArgs(1),
	Example: "super_hooks run pre-commit",
	RunE: func(cmd *cobra.Command, args []string) error {
		errors := []error{}

		for _, cmd := range hook.For(args[0]) {
			cmd.Stdout = os.Stdout
			cmd.Stderr = os.Stderr
			cmd.Args = append(cmd.Args, args[1:]...)
			if err := cmd.Run(); err != nil {
				errors = append(errors, err)
			}
		}

		if len(errors) > 0 {
			os.Exit(1)
		} else {
			os.Exit(0)
		}
		return nil
	},
}

func init() {
	RootCmd.AddCommand(runCmd)
}
