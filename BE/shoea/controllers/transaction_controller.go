package controllers

import (
	"net/http"
	"shoea/models"
	"strconv"

	"github.com/labstack/echo/v4"
)

func AddToTransaction(c echo.Context) error {
	claim := getTokenInfo(c)
	transactionID, err := strconv.Atoi(c.FormValue("transaction_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	userID := claim.ID
	shoeID, err := strconv.Atoi(c.FormValue("shoe_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	color := c.FormValue("color")
	size, err := strconv.Atoi(c.FormValue("size"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	qty, err := strconv.Atoi(c.FormValue("qty"))
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
	payment := c.FormValue("payment")
	created_at := c.FormValue("created_at")

	res, err := models.AddToTransaction(transactionID, userID, shoeID, color, size, qty, price, payment, created_at)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func GetAllTransaction(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID

	res, err := models.GetAllTransaction(userID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}
