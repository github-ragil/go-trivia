package main

import (
	"fmt"
	"os"
	"time"
)

func logPrint(message string, status bool) {
	now := time.Now().String()
	var slog string
	if status {
		slog = "OK"
	} else {
		slog = "ERROR"
	}
	log := fmt.Sprintf("[%s] %s => %s", slog, now, message)
	fmt.Println(log)
}

func retrieveDate() (nowmonth string, nowdate int) {
	loc, _ := time.LoadLocation("Asia/Jakarta")

	now := time.Now().In(loc)
	nowmonth = now.Month().String()
	nowdate = now.Day()

	return nowmonth, nowdate
}

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}
