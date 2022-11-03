package controllers

import (
	"net/http"
	"shoea/models"
	"strconv"

	"github.com/labstack/echo/v4"
)

func AddToCart(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID
	shoeID, err := strconv.Atoi(c.Param("shoe_id"))
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

	res, err := models.AddToCart(userID, shoeID, color, size, qty)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func GetAllCarts(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID

	res, err := models.GetAllCarts(userID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func DeleteCart(c echo.Context) error {
	ID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	res, err := models.DeleteCart(ID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func UpdateQtyCart(c echo.Context) error {
	ID, err := strconv.Atoi(c.Param("id"))
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

	res, err := models.UpdateQtyCart(ID, qty)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}
