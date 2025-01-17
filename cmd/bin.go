package main

import (
	"context"
	"log"
	"os/signal"
	"syscall"
	"time"

	"github.com/interl1nk/tornet/config"
	"github.com/interl1nk/tornet/infrastructure"
	"github.com/interl1nk/tornet/pkg/logging"
)

func main() {
	cfg, err := config.New()
	if err != nil {
		log.Fatalf("Failed to load the config due to an error: %v", err.Error())
	}

	logger, err := logging.New(cfg)
	if err != nil {
		log.Fatalf("Failed to configure logger due to an error: %v", err.Error())
	}
	logger.Info("Logger connected successfully.")

	ctx, stop := signal.NotifyContext(context.Background(), syscall.SIGTERM, syscall.SIGINT)
	defer stop()

	app := infrastructure.New(logger, cfg)

	if err := app.Start(ctx); err != nil {
		logger.Errorf("Application stopped with error: %v", err)
	}

	shutdownCtx, cancel := context.WithTimeout(context.Background(), time.Duration(cfg.ContextTimeout)*time.Second)
	defer cancel()

	if err := app.Finish(shutdownCtx); err != nil {
		logger.Errorf("Failed to shutdown gracefully: %v", err)
	} else {
		logger.Info("Application stopped gracefully.")
	}
}
