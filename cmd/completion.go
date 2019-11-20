package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

// completionCmd represents the completion command
var completionCmd = &cobra.Command{
	Use:   "completion",
	Short: "Entry point for generating command completions",
}

// zshCmd represents the zsh completion command
var zshCmd = &cobra.Command{
	Use:   "zsh",
	Short: "Generate zsh completion scripts",
	Long: fmt.Sprintf(`Generate zsh completion scripts
To load completion run

To configure your zhell to load completions for each session add to your zshrc
%s completion zsh >> ~/.%s.zshrc
Alternatively, you can put it in any folder exposed by the $fpath environment`, os.Args[0], os.Args[0]),
	RunE: func(cmd *cobra.Command, args []string) error {
		return RootCmd.GenZshCompletion(os.Stdout)
	},
}

// bashCmd represents the bash completion command
var bashCmd = &cobra.Command{
	Use:   "bash",
	Short: "Generate bash completion scripts",
	Long: fmt.Sprintf(`Generate bash completion scripts

To load completion run

. <(%s completion bash)
To configure your bash shell to load completions for each session add to your bashrc
%s completion bash >> ~/.bashrc`, os.Args[0], os.Args[0]),
	RunE: func(cmd *cobra.Command, args []string) error {
		RootCmd.GenBashCompletion(os.Stdout)
		return nil
	},
}

func init() {
	completionCmd.AddCommand(zshCmd)
	completionCmd.AddCommand(bashCmd)
	RootCmd.AddCommand(completionCmd)
}
