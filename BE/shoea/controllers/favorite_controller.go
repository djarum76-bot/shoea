package controllers

import (
	"net/http"
	"shoea/models"
	"strconv"

	"github.com/labstack/echo/v4"
)

func AddToFavorite(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID
	shoeID, err := strconv.Atoi(c.Param("shoe_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	res, err := models.AddToFavorite(userID, shoeID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func DeleteFromFavorite(c echo.Context) error {
	favoriteID, err := strconv.Atoi(c.Param("favorite_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	res, err := models.DeleteFromFavorite(favoriteID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func GetFavorite(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID
	shoeID, err := strconv.Atoi(c.Param("shoe_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	res, err := models.GetFavorite(shoeID, userID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func GetAllFavoriteShoes(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID

	res, err := models.GetAllFavoriteShoes(userID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func GetAllFavoriteShoesByBrand(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID
	brand := c.Param("brand")

	res, err := models.GetAllFavoriteShoesByBrand(userID, brand)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}
