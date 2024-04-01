// Copyright 2019-2023, Antonio Alvarado Hernández <tnotstar@gmail.com>

package main

import (
    "io"
    "fmt"
    "net/http"
    "net/url"
    "os"
)

const openWeatherMapBaseUrl = "https://api.openweathermap.org/data/2.5/weather"
const openWeatherMapEnvar = "OPENWEATHER_API_KEY"


func makeUrl(query string) (string, error) {
    u, err := url.Parse(openWeatherMapBaseUrl)
    if err != nil {
        return "", err
    }

    q := u.Query()
    q.Add("q", query)
    q.Add("mode", "json")
    q.Add("units", "metric")
    q.Add("lang", "es")
    q.Add("appid", os.Getenv(openWeatherMapEnvar))
    u.RawQuery = q.Encode()

    return u.String(), nil
}

func main() {
    if len(os.Args) < 2 {
        fmt.Println("Usage: weather <city-name>")
        os.Exit(1)
    }
    url, err := makeUrl(os.Args[1])
    if err != nil {
        panic(err)
    }

    res, err := http.Get(url)
    if (err != nil) {
        panic(err)
    }
    defer res.Body.Close()

    body, err := io.ReadAll(res.Body)
    if (err != nil) {
        panic(err)
    }
    fmt.Println(string(body))
}

