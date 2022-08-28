package main

import (
	"bufio"
	"fmt"
	"net/http"
)

func main() {
	port := 8080

	http.HandleFunc("/", handlerIndex)
	http.HandleFunc("/ping", handlerPing)

	var address = fmt.Sprintf(":%d", port)
	fmt.Printf("trivia backend server started at %d\n", port)
	err := http.ListenAndServe(address, nil)
	if err != nil {
		panic(err)
	}
}

func errorResponse(w http.ResponseWriter) {
	http.Error(w, "Internal Server Error", http.StatusInternalServerError)
}

func handlerPing(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("Hello from triviapp backend"))
}

func handlerIndex(w http.ResponseWriter, r *http.Request) {
	nowmonth, nowdate := retrieveDate()

	url := fmt.Sprintf("http://numbersapi.com/%d/%d/date", nowmonth, nowdate)
	resp, err := http.Get(url)
	if err != nil {
		errorResponse(w)
		logPrint(err.Error(), false)
		return
	}

	defer resp.Body.Close()

	if resp.StatusCode == 200 {
		scanner := bufio.NewScanner(resp.Body)

		if err := scanner.Err(); err != nil {
			errorResponse(w)
			logPrint(err.Error(), false)
		} else {
			if scanner.Scan() {
				message := fmt.Sprintln(scanner.Text())
				w.WriteHeader(http.StatusOK)
				w.Write([]byte(message))
				logPrint(message, true)

			} else {
				errorResponse(w)
				logPrint("Empty Result", false)
			}
		}
	} else {
		errorResponse(w)
		logPrint(fmt.Sprintf("Server Not Responding %d", resp.StatusCode), false)
	}

}
