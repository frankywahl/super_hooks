package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

func newCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "new",
		Short: "New gives templates for new git hooks",
		Long:  "New generate a new template for a hooks command",
	}

	cmd.AddCommand(newBashCmd())
	return cmd
}

func newBashCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "bash",
		Short: "Bash template for hooks command",
		Long:  "Bash template output to standard out",
		RunE: func(cmd *cobra.Command, args []string) error {
			fmt.Printf(`#!/usr/bin/env bash
if [ "${1}" == "--about" ]; then
	echo "Template Descriptiont of command"
	exit 0
fi
`)
			return nil
		},
	}

	return cmd
}
