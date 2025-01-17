package infrastructure

import (
	"context"
	"net/http"

	"github.com/interl1nk/tornet/application/services"
	"github.com/interl1nk/tornet/config"
	"github.com/interl1nk/tornet/pkg/logging"
)

type AppMethods interface {
	Start(ctx context.Context) error
	Finish(ctx context.Context) error
}

type Application struct {
	App    *GoApp
	tor    services.AppService
	client *http.Client
}

func New(logger *logging.Logger, cfg config.Config) AppMethods {
	logger.Info("Initializing the application...")
	goApp := NewGoApp(logger, cfg)

	logger.Info("Initializing services...")
	torSvc := services.NewAppService(logger, cfg, goApp.client)

	return &Application{
		App:    goApp,
		tor:    torSvc,
		client: goApp.client,
	}
}

func (a Application) Start(ctx context.Context) error {
	err := a.tor.GetBridges(ctx)
	if err != nil {
		a.App.logger.Errorf("Failed to get bridges: %v", err)
		return err
	}
	return nil
}

func (a Application) Finish(ctx context.Context) error {
	return a.App.Shutdown(ctx)
}
