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

func newGoCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "go",
		Short: "Go template for hooks command",
		Long:  "Go template output to standard out",
		RunE: func(cmd *cobra.Command, args []string) error {
			fmt.Printf(`package main

import (
	"context"
	"flag"
	"fmt"
	"log"
)

func main() {
	var about bool
	flag.BoolVar(&about, "about", false, "know about this command")
	flag.Parse()

	if about {
		fmt.Println("Describe command here")
		return
	}

	ctx := context.Background()
	if err := run(ctx); err != nil {
		log.Fatal(err)
	}
}

func run(ctx context.Context) error {
	return nil
}
`)
			return nil
		},
	}

	return cmd
}
