package controllers

import (
	"net/http"
	"shoea/models"
	"strconv"

	"github.com/labstack/echo/v4"
)

func AddToOrder(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID
	shoeID, err := strconv.Atoi(c.FormValue("shoe_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	originCityID, err := strconv.Atoi(c.FormValue("origin_city_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	destinationCityID, err := strconv.Atoi(c.FormValue("destination_city_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	price, err := strconv.Atoi(c.FormValue("price"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	etd := c.FormValue("etd")
	createdAt := c.FormValue("created_at")

	res, err := models.AddToOrder(userID, shoeID, originCityID, destinationCityID, price, etd, createdAt)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func GetAllOrder(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID

	res, err := models.GetAllOrder(userID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}
