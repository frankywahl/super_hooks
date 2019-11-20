package cmd

import (
	"encoding/json"
	"fmt"
	"os"
	"text/template"
	"time"

	"github.com/frankywahl/super_hooks/version"
	"github.com/spf13/cobra"
)

// VersionData represents all the information for a version
type VersionData struct {
	CreatedAt time.Time `json:"created_at"`
	Version   string    `json:"version,omitempty"`
	Revision  string    `json:"revision,omitempty"`
}

func newVersionCmd() *cobra.Command {
	format := `{{ . | json }}`

	funcMap := template.FuncMap{
		"json": func(i interface{}) (string, error) {
			b, err := json.Marshal(i)
			if err != nil {
				return "", fmt.Errorf("could not marshal data: %w", err)
			}
			return string(b), nil
		},
	}

	cmd := &cobra.Command{
		Use:   "version",
		Short: fmt.Sprintf("Print out %s version information", os.Args[0]),
		Long: fmt.Sprintf(`Get the current version of %s

The -f flag still specifies a format template
applied to a Go struct

type versionData struct {
	CreatedAt time.Time
	Version   string
	Revision  string
}`, os.Args[0]),
		Args:    cobra.NoArgs,
		Aliases: []string{"v"},
		RunE: func(cmd *cobra.Command, args []string) error {
			data := &VersionData{
				CreatedAt: time.Now().UTC(),
				Version:   version.Version,
				Revision:  version.GitRevision,
			}
			tpl, err := template.New("version").Funcs(funcMap).Parse(format + "\n")
			if err != nil {
				return fmt.Errorf("could not create template: %w", err)
			}
			return tpl.Execute(os.Stdout, data)
		},
	}

	cmd.Flags().StringVarP(&format, "format", "f", format, "define a format for printing")

	return cmd
}
func init() {
	rootCmd.AddCommand(newVersionCmd())
}
