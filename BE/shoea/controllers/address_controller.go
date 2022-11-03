package controllers

import (
	"net/http"
	"shoea/models"
	"strconv"

	"github.com/labstack/echo/v4"
)

func AddAddress(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID
	provinceID, err := strconv.Atoi(c.FormValue("province_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	cityID, err := strconv.Atoi(c.FormValue("city_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	lat, err := strconv.ParseFloat(c.FormValue("lat"), 64)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	lng, err := strconv.ParseFloat(c.FormValue("lng"), 64)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	addressName := c.FormValue("address_name")
	addressDetail := c.FormValue("address_detail")

	res, err := models.AddAddress(userID, provinceID, cityID, lat, lng, addressName, addressDetail)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func GetAllAddress(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID

	res, err := models.GetAllAddress(userID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func GetDefaultAddress(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID

	res, err := models.GetDefaultAddress(userID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func ChangeDefaultAddress(c echo.Context) error {
	claim := getTokenInfo(c)
	userID := claim.ID
	ID := c.Param("id")

	res, err := models.ChangeDefaultAddress(userID, ID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}

func UpdateAddress(c echo.Context) error {
	ID := c.Param("id")
	provinceID, err := strconv.Atoi(c.FormValue("province_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	cityID, err := strconv.Atoi(c.FormValue("city_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}
	addressName := c.FormValue("address_name")
	addressDetail := c.FormValue("address_detail")

	res, err := models.UpdateAddress(ID, provinceID, cityID, addressName, addressDetail)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"message": err.Error(),
		})
	}

	return c.JSON(http.StatusOK, res)
}
