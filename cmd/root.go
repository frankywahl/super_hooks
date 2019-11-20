package cmd

import (
	"fmt"
	"os"
	"path"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var cfgFile string

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
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
		}
		return runCmd.RunE(cmd, []string{fileName})
	},
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Printf("Error: %s\n\n", err)
		os.Exit(-1)
	}
}

// Verbose allows commands to get more output
var Verbose bool

func init() {
	cobra.OnInitialize(initConfig)

	rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/.super_hooks.yaml)")
	rootCmd.PersistentFlags().BoolVarP(&Verbose, "verbose", "v", false, "verbose output")
}

// initConfig reads in config file and ENV variables if set.
func initConfig() {
	if cfgFile != "" {
		// Use config file from the flag.
		viper.SetConfigFile(cfgFile)
	} else {
		// Find home directory.
		home, err := os.UserHomeDir()
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}

		// Search config in home directory with name ".super_hooks" (without extension).
		viper.AddConfigPath(".")
		viper.AddConfigPath(home)
		viper.SetConfigName(".super_hooks")
	}

	viper.AutomaticEnv() // read in environment variables that match

	// If a config file is found, read it in.
	if err := viper.ReadInConfig(); err == nil {
		fmt.Println("Using config file:", viper.ConfigFileUsed())
	}
}
