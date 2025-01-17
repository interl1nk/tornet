package helpers

import (
	"fmt"
	"os"
)

func CreateFile(fileName string) (*os.File, error) {
	file, err := os.Create(fileName)
	if err != nil {
		return nil, fmt.Errorf("не удалось создать файл: %w", err)
	}

	return file, nil
}
