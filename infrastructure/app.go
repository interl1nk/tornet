package infrastructure

import (
	"context"
	"net/http"
	"time"

	"github.com/interl1nk/tornet/config"
	"github.com/interl1nk/tornet/pkg/logging"
)

type GoApp struct {
	cfg    config.Config
	logger *logging.Logger
	client *http.Client
}

func NewGoApp(logger *logging.Logger, cfg config.Config) *GoApp {
	client := &http.Client{
		Timeout: time.Duration(cfg.Client.Timeout) * time.Second,
		Transport: &http.Transport{
			MaxIdleConns:      cfg.Client.MaxIdleConns,
			IdleConnTimeout:   time.Duration(cfg.Client.IdleConnTimeout) * time.Second,
			DisableKeepAlives: cfg.Client.DisableKeepAlives,
		},
	}

	return &GoApp{
		logger: logger,
		client: client,
	}
}

func (a GoApp) Shutdown(ctx context.Context) error {
	a.logger.Info("Shutting down application...")

	done := make(chan struct{})
	go func() {
		defer close(done)

		a.logger.Info("Closing HTTP connection.")
		if transport, ok := a.client.Transport.(*http.Transport); ok {
			transport.CloseIdleConnections()
			a.logger.Info("HTTP connections closed.")
		}
	}()

	select {
	case <-done:
		a.logger.Info("Shutdown completed successfully.")
	case <-ctx.Done():
		a.logger.Warn("Shutdown aborted due to context cancellation.")
		return ctx.Err()
	}

	return nil
}
