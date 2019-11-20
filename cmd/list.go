package cmd

import (
	"bytes"
	"fmt"

	"github.com/frankywahl/super_hooks/hook"
	"github.com/spf13/cobra"
)

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
		writeBuffer := bytes.NewBufferString("")
		for _, h := range hook.List {

			cmds := hook.For(h)
			if len(cmds) > 0 || Verbose {
				fmt.Fprintf(writeBuffer, h)
				fmt.Fprintf(writeBuffer, "\n-------------\n")
			}

			for _, cmd := range cmds {
				cmd.Stdout = writeBuffer
				cmd.Args = append(cmd.Args, "--about")
				fmt.Fprintf(writeBuffer, cmd.Args[0])
				fmt.Fprintf(writeBuffer, "\t")
				fmt.Fprintf(writeBuffer, "\n\t  ~> ")
				cmd.Run()
				fmt.Println(writeBuffer)
				writeBuffer.Reset()
			}
		}
		return nil
	},
}

func init() {
	rootCmd.AddCommand(listCmd)
}
