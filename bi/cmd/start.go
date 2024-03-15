/*
Copyright © 2024 Elliott Clark <elliott@batteriesincl.com>
*/
package cmd

import (
	"bi/pkg/start"

	"log/slog"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

// startCmd represents the start command
var startCmd = &cobra.Command{
	Use:   "start",
	Short: "Start a Batteries Included Installation",
	Long: `This will get the configuration for the 
	installation and start the installation process.
	
	If the installation is already started, it will 
	complete the installation and sync all resources 
	that should be created but weren't.
	
	First step is to ensure the kubernetes cluster is started as specified.
	
	The options are:
	
	- Start an EKS cluster
	- Start a local kubernetes cluster using Kind and docker
	- Use an existing kubernetes cluster
	
	Then all the bootstrap resources are created.
	
	Then the cli waits until the installation is 
	complete displaying a url for running control server.`,
	Run: func(cmd *cobra.Command, args []string) {
		installUrl, err := cmd.Flags().GetString("install-spec")
		cobra.CheckErr(err)
		slog.Debug("Starting Batteries Included Installation", "url", installUrl)

		err = start.StartInstall(installUrl)
		cobra.CheckErr(err)
	},
}

func init() {
	RootCmd.AddCommand(startCmd)
	// The install spec path as an argument
	// that can be parsed by net/url
	startCmd.Flags().StringP("install-spec", "i", "", "The install spec to use")
	viper.BindPFlag("install-spec", startCmd.Flags().Lookup("install-spec"))
}
