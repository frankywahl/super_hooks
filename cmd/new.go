package cmd

import (
	"io"
	"os"

	"github.com/frankywahl/super_hooks/internal/templates"
	"github.com/spf13/cobra"
)

func printFile(dst io.Writer, file string) error {
	f, err := templates.Assets.Open(file)
	if err != nil {
		return err
	}
	defer f.Close()
	if _, err := io.Copy(os.Stdout, f); err != nil {
		return err
	}
	return nil
}

func newCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "new",
		Short: "New gives templates for new git hooks",
		Long:  "New generate a new template for a hooks command",
	}

	cmd.AddCommand(
		newBashCmd(),
		newGoCmd(),
	)
	return cmd
}

func newBashCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "bash",
		Short: "Bash template for hooks command",
		Long:  "Bash template output to standard out",
		RunE: func(cmd *cobra.Command, args []string) error {
			return printFile(os.Stdout, "bash")
		},
	}

	return cmd
}

func newGoCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "go",
		Short: "Go template for hooks command",
		Long:  "Go template output to standard out",
		RunE: func(cmd *cobra.Command, args []string) error {
			return printFile(os.Stdout, "go")
		},
	}

	return cmd
}
