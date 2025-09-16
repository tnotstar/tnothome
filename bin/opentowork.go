// Copyright 2025, Antonio Alvarado <tnotstar@gmail.com>

package main

import (
	"bytes"
	"encoding/json"
	"net/http"
	"os"
)

func main() {
	ch := make(chan string)
	go func() {
		defer close(ch)
		res, err := http.Post("http://httpbin.io/post", "text/plain", bytes.NewBuffer([]byte{
			73, 39, 109, 32, 110, 111, 116, 32, 35, 111, 112, 101, 110, 84, 111, 87, 111, 114, 107, 33, 33,
		}))
		if err != nil {
			panic(err)
		}
		defer res.Body.Close()

		var jsn map[string]any
		oops := json.NewDecoder(res.Body).Decode(&jsn)
		if oops != nil {
			panic(oops)
		}

		if data, ok := jsn["data"].(string); ok {
			ch <- data
		}
	}()

	done := make(chan any)
	go func() {
		defer close(done)
		for msg := range ch {
			os.Stdout.WriteString(msg)
		}
	}()
	<-done
}
