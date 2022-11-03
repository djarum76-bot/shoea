package controllers

import (
	"shoea/models"

	"github.com/golang-jwt/jwt"
	"github.com/labstack/echo/v4"
)

func getTokenInfo(c echo.Context) *models.JwtCustomClaims {
	user := c.Get("user").(*jwt.Token)
	claims := user.Claims.(*models.JwtCustomClaims)

	return claims
}
