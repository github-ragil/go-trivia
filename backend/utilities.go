package main

import (
	"fmt"
	"os"
	"time"
)

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}

func retrieveDate() (nowmonth int, nowdate int) {
	loc, _ := time.LoadLocation("Asia/Jakarta")

	now := time.Now().In(loc)
	nowmonth = int(now.Month())
	nowdate = now.Day()

	return nowmonth, nowdate
}

func logPrint(message string, status bool) {
	loc, _ := time.LoadLocation("Asia/Jakarta")

	now := time.Now().In(loc).String()
	var slog string
	if status {
		slog = "OK"
	} else {
		slog = "ERROR"
	}
	log := fmt.Sprintf("[%s] %s => %s", slog, now, message)
	fmt.Println(log)
}
