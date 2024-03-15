/*
Copyright © 2024 Elliott Clark
*/
package cmd

import (
	"log/slog"
	"os"
	"time"

	"github.com/adrg/xdg"
	"github.com/lmittmann/tint"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var cfgFile string
var verbose string
var color bool

// rootCmd represents the base command when called without any subcommands
var RootCmd = &cobra.Command{
	Use:   "bi",
	Short: "A CLI for Batteries Included infrastructure",
	Long: `An all in one cli for installing and
debugging Batteries Included infrastructure
on top of kubernetes`,
	PersistentPreRunE: func(cmd *cobra.Command, args []string) error {
		err := initLogging(verbose, color)
		if err != nil {
			return err
		}
		return nil
	},
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	err := RootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}

func init() {
	cobra.OnInitialize(initConfig)
	RootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $XDG_CONFIG_HOME/bi/bi.yaml)")
	RootCmd.PersistentFlags().StringVarP(&verbose, "verbosity", "v", slog.LevelWarn.String(), "Log level (debug, info, warn, error")
	RootCmd.PersistentFlags().BoolVarP(&color, "color", "c", true, "Use color in logs")
}

// initConfig reads in config file and ENV variables if set.
func initConfig() {
	if cfgFile != "" {
		// Use config file from the flag.
		viper.SetConfigFile(cfgFile)
	} else {
		// Find home directory.
		configDir, err := xdg.ConfigFile("bi")
		cobra.CheckErr(err)

		// Search config in config directory with name "bi.yaml"
		viper.AddConfigPath(configDir)
		viper.SetConfigName("bi")
		viper.SetConfigType("yaml")
	}

	viper.AutomaticEnv() // read in environment variables that match

	// If a config file is found, read it in.
	if err := viper.ReadInConfig(); err == nil {
		slog.Debug("Using config file", "file", viper.ConfigFileUsed())
	}
}

func initLogging(verbose string, color bool) error {
	var logLevel slog.Level

	w := os.Stderr

	err := logLevel.UnmarshalText([]byte(verbose))
	if err != nil {
		return err
	}

	// set global logger with custom options
	slog.SetDefault(slog.New(
		tint.NewHandler(w, &tint.Options{
			Level:      logLevel,
			AddSource:  logLevel == slog.LevelDebug,
			NoColor:    !color,
			TimeFormat: time.Kitchen,
		}),
	))

	return nil
}
