package handler

import (
	"github.com/labstack/echo/v4"
	"net/http"
	"time"
)

type PostExampleHandler struct {
}

func PostExample() *PostExampleHandler {
	return &PostExampleHandler{}
}

func (h *PostExampleHandler) Index() echo.HandlerFunc {
	return func(c echo.Context) error {
		time.Sleep(80 * time.Millisecond)
		type Data struct {
			Text string `json:"text"`
		}
		data := &Data{
			Text: "Post Example",
		}
		return c.JSON(200, data)
	}
}

func (h *PostExampleHandler) Post() echo.HandlerFunc {
	return func(c echo.Context) error {
		time.Sleep(80 * time.Millisecond)
		postData := c.FormValue("postData")
		if postData == "" {
			return echo.NewHTTPError(http.StatusBadRequest, "post data is required")
		}
		type Data struct {
			InputPostData string `json:"inputPostData"`
		}
		data := &Data{
			InputPostData: postData,
		}

		return c.JSON(200, data)
	}
}
