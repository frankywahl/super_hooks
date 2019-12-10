package cmd

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
	"sync"
	"text/tabwriter"

	"github.com/frankywahl/super_hooks/hook"
	"github.com/spf13/cobra"
)

type customHook struct {
	kind        string
	path        string
	description string
}

func (c *customHook) Write(b []byte) (int, error) {
	c.description = fmt.Sprintf("%s%s", c.description, string(b))
	c.description = strings.TrimSpace(c.description)
	return len(b), nil
}

var listCmd = &cobra.Command{
	Use:   "list",
	Short: "List out all hooks",
	Long: `
	List out the hooks that are set to run on the invocation
	from git of the hook.
	`,
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
						kind: h,
						path: cmd.Args[0],
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
		w := tabwriter.NewWriter(os.Stdout, 0, 0, 10, ' ', 0)
		fmt.Fprintf(w, "KIND\tPATH\tDESCRIPTION\n")
		for cmd := range hooks {
			fmt.Fprintf(w, "%s\t%s\t%s\t\n", cmd.kind, cmd.path, cmd.description)
		}
		w.Flush()
		return nil
	},
}

func init() {
	rootCmd.AddCommand(listCmd)
}
