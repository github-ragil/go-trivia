package main

import (
	"fmt"
	"html/template"
	"net/http"
	"path"
)

var basepath = path.Join(path.Base(""), "cmd", "triviafrontend")

func main() {
	port := 80

	http.HandleFunc("/", handlerIndex)
	http.HandleFunc("/ping", handlerPing)
	http.Handle("/static/",
		http.StripPrefix("/static/",
			http.FileServer(http.Dir(path.Join("./assets")))))

	var address = fmt.Sprintf(":%d", port)
	fmt.Printf("trivia frontend server started at %d\n", port)
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
	w.Write([]byte("Hello from triviapp frontend"))
}

func handlerIndex(w http.ResponseWriter, r *http.Request) {

	viewpath := path.Join("./views", "index.html")
	var tmpl, err = template.ParseFiles(viewpath)
	if err != nil {
		errorResponse(w)
		logPrint(err.Error(), false)
		return
	}

	trivia, err := getTrivia()
	if err != nil {
		errorResponse(w)
		logPrint(err.Error(), false)
		return
	}

	nowmonth, nowdate := retrieveDate()
	var data = map[string]interface{}{
		"title":  fmt.Sprintf("Today Trivia %d %s", nowdate, nowmonth),
		"trivia": trivia,
	}

	err = tmpl.Execute(w, data)
	if err != nil {
		errorResponse(w)
		logPrint(err.Error(), false)
	} else {
		logPrint("Index Access 200", true)
	}
}
