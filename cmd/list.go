package cmd

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
	"sync"
	"text/tabwriter"
	"text/template"

	"github.com/frankywahl/super_hooks/hook"
	"github.com/spf13/cobra"
)

type customHook struct {
	Kind        string
	Path        string
	Description string
}

func (c *customHook) Write(b []byte) (int, error) {
	c.Description = fmt.Sprintf("%s%s", c.Description, string(b))
	c.Description = strings.TrimSpace(c.Description)
	return len(b), nil
}

func newListCmd() *cobra.Command {
	format := ""
	cmd := &cobra.Command{
		Use:   "list",
		Short: "List out all hooks",
		Long: `
		List out the hooks that are set to run on the invocation
		from git of the hook.

The -f flag still specifies a format template
applied to a Go struct

type hook struct {
	Kind        string
	Path        string
	Description string
}`,
		Args:    cobra.NoArgs,
		Aliases: []string{"l"},
		RunE: func(cmd *cobra.Command, args []string) error {
			var wg sync.WaitGroup
			hooks := make(chan customHook)

			for _, h := range hook.List {
				for _, cmd := range hook.For(h) {
					wg.Add(1)
					go func(cmd *exec.Cmd, h string) {
						defer wg.Done()
						ch := customHook{
							Kind: h,
							Path: cmd.Args[0],
						}
						cmd.Stdout = &ch
						cmd.Args = append(cmd.Args, "--about")
						if err := cmd.Run(); err != nil {
							fmt.Printf("error when running: %v", err)
							return
						}
						hooks <- ch
					}(cmd, h)
				}
			}
			go func() {
				wg.Wait()
				close(hooks)
			}()
			return printHooks(hooks, format)
		},
	}

	cmd.Flags().StringVarP(&format, "format", "f", "", "define a format for printing")
	return cmd
}

func printHooks(hooks <-chan customHook, format string) error {
	if format == "" {
		w := tabwriter.NewWriter(os.Stdout, 0, 0, 10, ' ', 0)
		fmt.Fprintf(w, "KIND\tPATH\tDESCRIPTION\n")
		for cmd := range hooks {
			fmt.Fprintf(w, "%s\t%s\t%s\t\n", cmd.Kind, cmd.Path, cmd.Description)
		}
		return w.Flush()
	} else {
		tpl, err := template.New("listCmd").Parse(format)
		if err != nil {
			return fmt.Errorf("could not create template: %w", err)
		}
		for cmd := range hooks {
			tpl.Execute(os.Stdout, cmd)
			fmt.Fprintln(os.Stdout)
		}
	}
	return nil
}
