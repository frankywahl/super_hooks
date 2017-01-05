package main

import (
	"bytes"
	"flag"
	"fmt"
	"log"
	"os"
	"path"
	"path/filepath"

	"github.com/frankywahl/super_hooks/git"
	"github.com/frankywahl/super_hooks/hook"
)

func main() {
	file, err := os.Executable()
	if err != nil {
		log.Fatal(err)
	}

	install := flag.Bool("install", false, "Replace existing hooks in this repository with a call to git hooks run [hook]\n\tMoves old hooks directory to hooks.old")
	uninstall := flag.Bool("uninstall", false, "Remove superhooks\n\tRemoves hooks in this repository and rename hooks.old back to hooks")
	fileToRun := flag.String("run", path.Base(file), "run hooks for CMD (such as pre-commit)")
	list := flag.Bool("list", false, "list current hooks (for option)")
	help := flag.Bool("help", false, "display the help")

	flag.Parse()

	if *help {
		fmt.Fprintf(os.Stderr, "Usage: %s [options]:\n\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "A tool to manage project, user, and global Git hooks for multiple git repositories.\n\n")
		flag.PrintDefaults()
		fmt.Fprintf(os.Stderr, "\nSupported hooks are ")
		for _, h := range hook.List() {
			fmt.Fprintf(os.Stderr, "%s ", h.Name)
		}
		fmt.Fprintf(os.Stderr, "\n")
		return
	}

	if *install {
		if folder, err := git.TopLevel(); err != nil {
			panic(err)
		} else {
			originalDir := filepath.Join(folder, ".git", "hooks")
			destinationDir := filepath.Join(folder, ".git", "hooks.back")
			directoryExists, _ := exists(destinationDir)
			if directoryExists {
				fmt.Println(destinationDir, " already exists")
			} else {
				if err := os.Rename(originalDir, destinationDir); err != nil {
					fmt.Println(err)
				}
				if err := os.Mkdir(originalDir, os.ModePerm); err != nil {
					fmt.Println(err)
				}

				for _, h := range hook.List() {
					exec, _ := os.Executable()
					if err := os.Symlink(exec, filepath.Join(originalDir, h.Name)); err != nil {
						fmt.Println(err)
					}

				}
			}
			return
		}

	}

	if *uninstall {
		if folder, err := git.TopLevel(); err != nil {
			panic(err)
		} else {
			originalDir := filepath.Join(folder, ".git", "hooks")
			destinationDir := filepath.Join(folder, ".git", "hooks.back")
			directoryExists, _ := exists(destinationDir)
			if !directoryExists {
				fmt.Println("Super hooks is not installed")
			} else {
				if err := os.RemoveAll(originalDir); err != nil {
					panic(err)
				}
				if err := os.Rename(destinationDir, originalDir); err != nil {
					fmt.Println(err)
				}
			}
			return
		}
	}

	if *list || *fileToRun == "super_hooks" {
		for _, h := range hook.List() {
			writeBuffer := bytes.NewBufferString("")
			if len(h.Executables()) > 0 {
				fmt.Fprintf(writeBuffer, h.Name)
				fmt.Fprintf(writeBuffer, "\n-------------\n")
				for _, executable := range h.Executables() {
					fmt.Fprintf(writeBuffer, "\t")
					fmt.Fprintf(writeBuffer, executable.FilePath)
					fmt.Fprintf(writeBuffer, "\n\t  ~> ")
					executable.Stdout = writeBuffer
					executable.Explain()
					fmt.Println(writeBuffer)
					writeBuffer.Reset()
				}
			}
		}
		return
	}

	if hookObject, err := hook.For(*fileToRun); err != nil {
		if err != nil {
			fmt.Println("Hook", path.Base(file), "not existent")
			os.Exit(1)
		}
	} else {
		errors := []error{}
		for _, executable := range hookObject.Executables() {
			if err := executable.Run(); err != nil {
				errors = append(errors, err)
			}
		}

		if len(errors) > 0 {
			os.Exit(1)
		} else {
			os.Exit(0)
		}
	}
}

// exists returns whether the given file or directory exists or not
func exists(path string) (bool, error) {
	_, err := os.Stat(path)
	if err == nil {
		return true, nil
	}
	if os.IsNotExist(err) {
		return false, nil
	}
	return true, err
}
