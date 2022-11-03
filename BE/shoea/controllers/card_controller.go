package controllers

import (
	"net/http"
	"shoea/models"

	"github.com/labstack/echo/v4"
)

func AddCard(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID
	bankName := c.FormValue("bank_name")
	number := c.FormValue("number")
	expired := c.FormValue("expired_date")
	cvv := c.FormValue("cvv")
	holder := c.FormValue("card_holder")

	res, err := models.AddCard(userID, bankName, number, expired, cvv, holder)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func GetAllCard(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID

	res, err := models.GetAllCard(userID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func GetDefaultCard(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID

	res, err := models.GetDefaultCard(userID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func ChangeDefaultCard(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID
	ID := c.Param("id")

	res, err := models.ChangeDefaultCard(userID, ID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}
