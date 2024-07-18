package main

import (
	"fmt"
	"log"
	"net/http"
	"os/exec"
	"time"
)

func main() {
	// Start timer
	start := time.Now()

	// Start the Docker container
	cmd := exec.Command("docker", "run", "-d", "--name", "go-scratch-app-container", "-p", "8080:8080", "-e", "NAME=Will", "go-scratch-app")
	if err := cmd.Run(); err != nil {
		log.Fatalf("Failed to start container: %v", err)
	}

	// Wait for the app to respond
	for {
		resp, err := http.Get("http://localhost:8080")
		if err == nil && resp.StatusCode == http.StatusOK {
			break
		}
		time.Sleep(10 * time.Millisecond)
	}

	// Stop the timer
	elapsed := time.Since(start)

	// Log the elapsed time
	fmt.Printf("Container started and responded in %s\n", elapsed)

	// Stop and remove the container
	stopCmd := exec.Command("docker", "stop", "go-scratch-app-container")
	if err := stopCmd.Run(); err != nil {
		log.Fatalf("Failed to stop container: %v", err)
	}

	rmCmd := exec.Command("docker", "rm", "go-scratch-app-container")
	if err := rmCmd.Run(); err != nil {
		log.Fatalf("Failed to remove container: %v", err)
	}
}
