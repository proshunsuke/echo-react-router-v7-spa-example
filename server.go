package main

import (
	"echo-react-router-v7-spa-example/handler"
	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()
	g := e.Group("/api")
	g.GET("/post-example", handler.PostExample().Index())
	g.POST("/post-example", handler.PostExample().Post())
	e.Logger.Fatal(e.Start(":1323"))
}
