package file_runner

import (
	"io"
	"log"
	"os"
	"os/exec"
)

// FileRunner represent a file hook that can be ran
type FileRunner struct {
	FilePath string
	Stdout   io.Writer
	Stderr   io.Writer
}

// New returns a new FileRunner
func New(filePath string) FileRunner {
	return FileRunner{FilePath: filePath, Stdout: os.Stdout, Stderr: os.Stderr}
}

// Explain will put into the buffer the value of running the hook with the --about
// flag. This is nice to have a quick info on every hook.
func (f *FileRunner) Explain() {
	cmd := exec.Command(f.FilePath, "--about")

	cmd.Stdout = f.Stdout
	cmd.Stderr = f.Stderr

	err := cmd.Run()
	if err != nil {
		log.Printf("Error on %s\n", f.FilePath)
	}
}

// Run will actually execute the binary. If any error is
// raised when the binary is ran, this error is returned to
// caller. It returns nil on successful run
func (f *FileRunner) Run() error {
	cmd := exec.Command(f.FilePath)

	cmd.Stdout = f.Stdout
	cmd.Stderr = f.Stderr

	return cmd.Run()
}
