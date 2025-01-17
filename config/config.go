package config

import (
	"log"
	"os"

	"github.com/ilyakaznacheev/cleanenv"
)

type Config struct {
	Logger         loggerConfig `yaml:"logger"`
	Client         clientConfig `yaml:"client"`
	Tor            torConfig    `yaml:"tor"`
	Output         outputConfig `yaml:"output"`
	ContextTimeout int          `yaml:"context_timeout"`
}

type loggerConfig struct {
	Writer string `yaml:"writer"`
	Level  string `yaml:"level"`
}

type torConfig struct {
	ReqType string `yaml:"req_type"`
	Url     string `yaml:"url"`
}

type outputConfig struct {
	FileName string `yaml:"file_name"`
}

type clientConfig struct {
	Timeout           int  `yaml:"timeout"`
	MaxIdleConns      int  `yaml:"max_idle_conns"`
	IdleConnTimeout   int  `yaml:"idle_conn_timeout"`
	DisableKeepAlives bool `yaml:"disable_keep_alives"`
}

func New() (Config, error) {
	instance := Config{}
	log.Println("Reading application's configuration")

	useEnvConfig := os.Getenv("USE_ENV_CONFIG") == "true"

	if !useEnvConfig {
		if err := cleanenv.ReadConfig("config.yml", &instance); err != nil {
			help, _ := cleanenv.GetDescription(instance, nil)
			log.Println("Configuration file error:")
			log.Println(help)
			return Config{}, err
		}
	}

	if err := cleanenv.ReadEnv(&instance); err != nil {
		return Config{}, err
	}

	return instance, nil
}
