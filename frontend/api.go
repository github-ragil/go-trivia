package main

import (
	"bufio"
	"fmt"
	"net/http"
)

func getTrivia() (string, error) {
	backendURL := getEnv("BACKEND_URL", "http://mraagil-triviapp-backend.default.svc.cluster.local:8080")
	var trivia string

	resp, err := http.Get(backendURL)
	if err != nil {
		return trivia, err
	}

	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return trivia, fmt.Errorf("Server Not Responding %d", resp.StatusCode)
	}

	scanner := bufio.NewScanner(resp.Body)

	if err := scanner.Err(); err != nil {
		return trivia, err
	}

	if !scanner.Scan() {
		return trivia, fmt.Errorf("Empty Result")
	}

	trivia = fmt.Sprintln(scanner.Text())
	return trivia, nil
}
