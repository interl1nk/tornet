package helpers

import (
	"fmt"
	"os"
	"regexp"
)

func MatchHtmlStringsAndSaveTheFile(htmlContent []byte, file *os.File) (string, error) {
	htmlString := string(htmlContent)
	re := regexp.MustCompile(`obfs4 .*? iat-mode=\d`)

	matches := re.FindAllString(htmlString, -1)
	if matches == nil {
		return "no matching HTML strings were found in the content", nil
	}

	for _, line := range matches {
		if _, err := file.WriteString(line + "\n"); err != nil {
			return "", fmt.Errorf("failed to write to file: %w", err)
		}
	}

	return "", nil
}
