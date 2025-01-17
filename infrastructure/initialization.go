package infrastructure

import (
	"context"
	"net/http"

	"github.com/interl1nk/tornet/application/services"
	"github.com/interl1nk/tornet/config"
	"github.com/interl1nk/tornet/pkg/logging"
)

type Application struct {
	App    *GoApp
	tor    services.AppService
	client *http.Client
}

func New(logger *logging.Logger, cfg config.Config) *Application {
	logger.Info("Initializing the application.")
	goApp := NewGoApp(logger, cfg)

	logger.Info("Initializing services.")
	torSvc := services.NewAppService(logger, cfg, goApp.client)

	return &Application{
		App:    goApp,
		tor:    torSvc,
		client: goApp.client,
	}
}

func (a Application) Start(ctx context.Context) error {
	a.App.logger.Info("Starting application.")
	err := a.tor.GetBridges(ctx)
	if err != nil {
		return err
	}
	a.App.logger.Info("Application started successfully.")
	return nil
}

func (a Application) Finish(ctx context.Context) error {
	return a.App.Shutdown(ctx)
}
