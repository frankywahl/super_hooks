package cmd

import (
	"bytes"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"sync"
	"time"

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
		now := time.Now()
		hooks := hook.For(args[0])
		err := runCommands(hooks, args[1:])
		if Verbose {
			fmt.Fprintf(os.Stdout, "took %s to run %d hooks\n", time.Since(now), len(hooks))
		}

		if err != nil {
			fmt.Fprintf(os.Stderr, "error running commands %v\n", err)
			os.Exit(1)
		}
		os.Exit(0)
		return nil
	},
}

func init() {
	RootCmd.AddCommand(runCmd)
}

func runCommands(cmds []*exec.Cmd, args []string) error {
	stoutc := make(chan string)
	sterrc := make(chan string)
	errc := make(chan *exec.Cmd)

	var wg sync.WaitGroup
	wg.Add(len(cmds))

	go func() {
		wg.Wait()
		close(stoutc)
		close(sterrc)
		close(errc)
	}()

	for _, cmd := range cmds {
		go func(c *exec.Cmd) {
			defer wg.Done()
			stdout := bytes.NewBuffer(nil)
			stderr := bytes.NewBuffer(nil)
			c.Stdout = stdout
			c.Stderr = stderr
			c.Args = args
			if err := c.Run(); err != nil {
				errc <- c
				sterrc <- fmt.Sprintf("%s", stderr)
			}

			stoutc <- fmt.Sprintf("%s", stdout)
		}(cmd)

	}

	errCount := 0
	for stoutc != nil || sterrc != nil {
		select {
		case data, ok := <-stoutc:
			if !ok {
				stoutc = nil
				continue
			}
			fmt.Fprintf(os.Stdout, data)
		case data, ok := <-sterrc:
			if !ok {
				sterrc = nil
				continue
			}
			fmt.Fprintf(os.Stderr, data)
		case _, ok := <-errc:
			if !ok {
				errc = nil
				continue
			}
			errCount++
		}
	}
	if errCount > 0 {
		return errors.New("did not finish successfully")
	}
	return nil
}
