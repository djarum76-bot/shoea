package controllers

import (
	"net/http"
	"shoea/models"
	"strconv"

	"github.com/labstack/echo/v4"
)

func AddShoe(c echo.Context) error {
	brand := c.FormValue("brand")
	image, err := c.FormFile("image")
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	title := c.FormValue("title")
	description := c.FormValue("description")

	form, err := c.MultipartForm()
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	arrSize := form.Value["size"]
	size := []int{}
	for _, i := range arrSize {
		j, err := strconv.Atoi(i)
		if err != nil {
			return c.JSON(http.StatusInternalServerError, map[string]string{
				"message": err.Error(),
			})
		}
		size = append(size, j)
	}

	color := form.Value["color"]

	price, err := strconv.Atoi(c.FormValue("price"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	res, err := models.AddShoe(brand, image, title, description, size, color, price)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func GetAllPopularShoes(c echo.Context) error {
	res, err := models.GetAllPopularShoes()
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func GetAllBrandShoes(c echo.Context) error {
	brand := c.Param("brand")
	res, err := models.GetAllBrandShoes(brand)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func GetShoe(c echo.Context) error {
	ID := c.Param("id")
	res, err := models.GetShoe(ID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}
