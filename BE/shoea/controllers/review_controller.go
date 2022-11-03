package controllers

import (
	"net/http"
	"shoea/models"
	"strconv"

	"github.com/labstack/echo/v4"
)

func AddReview(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID
	orderID, err := strconv.Atoi(c.FormValue("order_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	shoeID, err := strconv.Atoi(c.FormValue("shoe_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	rating, err := strconv.ParseFloat(c.FormValue("rating"), 32)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	comment := c.FormValue("comment")
	createdAt := c.FormValue("created_at")

	res, err := models.AddReview(userID, orderID, shoeID, float32(rating), comment, createdAt)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func GetAllReview(c echo.Context) error {
	shoeID, err := strconv.Atoi(c.Param("shoe_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	res, err := models.GetAllReview(shoeID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func GetAllReviewByRating(c echo.Context) error {
	shoeID, err := strconv.Atoi(c.Param("shoe_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	rating, err := strconv.ParseFloat(c.Param("rating"), 32)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	res, err := models.GetAllReviewByRating(shoeID, float32(rating))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}
