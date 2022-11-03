package controllers

import (
	"fmt"
	"net/http"
	"shoea/models"

	"github.com/labstack/echo/v4"
)

func GetUser(c echo.Context) error {
	claim := getTokenInfo(c)
	ID := fmt.Sprintf("%d", claim.ID)
	res, err := models.GetUser(ID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func FillUserProfile(c echo.Context) error {
	claim := getTokenInfo(c)
	ID := fmt.Sprintf("%d", claim.ID)
	picture, err := c.FormFile("picture")
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	name := c.FormValue("name")
	date := c.FormValue("date")
	phone := c.FormValue("phone")
	gender := c.FormValue("gender")

	res, err := models.FillUserProfile(ID, picture, name, date, phone, gender)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func FillUserPin(c echo.Context) error {
	claim := getTokenInfo(c)
	ID := fmt.Sprintf("%d", claim.ID)
	pin := c.FormValue("pin")

	res, err := models.FillUserPin(ID, pin)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func UpdatePhoto(c echo.Context) error {
	claim := getTokenInfo(c)
	ID := claim.ID
	picture, err := c.FormFile("picture")
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	res, err := models.UpdatePhoto(ID, picture)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func UpdateProfile(c echo.Context) error {
	claim := getTokenInfo(c)
	ID := claim.ID
	name := c.FormValue("name")
	date := c.FormValue("date")
	phone := c.FormValue("phone")
	gender := c.FormValue("gender")

	res, err := models.UpdateProfile(ID, name, date, phone, gender)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}
