package services

import (
	"context"
	"fmt"
	"io"
	"net/http"

	"github.com/interl1nk/tornet/application/services/helpers"
	"github.com/interl1nk/tornet/config"
	"github.com/interl1nk/tornet/pkg/logging"
)

type AppService interface {
	GetBridges(ctx context.Context) error
}

type appService struct {
	cfg    config.Config
	logger *logging.Logger
	client *http.Client
}

func NewAppService(logger *logging.Logger, cfg config.Config, client *http.Client) AppService {
	return &appService{
		cfg:    cfg,
		logger: logger,
		client: client,
	}
}

func (s *appService) GetBridges(ctx context.Context) error {
	s.logger.Info("Preparing for the HTTP request.")

	client := s.client
	url := s.cfg.Tor.Url
	reqType := s.cfg.Tor.ReqType
	output := s.cfg.Output.FileName

	file, err := helpers.CreateFile(output)
	if err != nil {
		s.logger.Errorf("%v", err)
		return err
	}
	defer file.Close()

	s.logger.Info("Sending a request.")
	req, err := http.NewRequest(reqType, url, nil)
	if err != nil {
		err = fmt.Errorf("error creating a request: %w", err)
		s.logger.Errorf("%v", err)
		return err
	}

	resp, err := client.Do(req.WithContext(ctx))
	if err != nil {
		err = fmt.Errorf("error sending a request: %w", err)
		s.logger.Errorf("%v", err)
		return err
	}
	defer resp.Body.Close()

	htmlContent, err := io.ReadAll(resp.Body)
	if err != nil {
		err = fmt.Errorf("error reading request's body: %w", err)
		s.logger.Errorf("%v", err)
		return err
	}

	warning, err := helpers.MatchHtmlStringsAndSaveTheFile(htmlContent, file)
	if err != nil {
		s.logger.Errorf("Error in MatchHtmlStringsAndSaveTheFile: %v", err)
		return fmt.Errorf("processing failed: %w", err)
	}
	if warning != "" {
		s.logger.Warnf("Warning: %s", warning)
	}

	s.logger.Info("Request completed successfully.")
	return nil
}
