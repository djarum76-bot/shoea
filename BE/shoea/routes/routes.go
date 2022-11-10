package routes

import (
	"shoea/controllers"
	"shoea/models"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func Init() *echo.Echo {
	e := echo.New()

	e.Static("/profile", "profile")
	e.Static("/image", "image")

	e.POST("/register", controllers.Register)
	e.POST("/login", controllers.Login)
	e.POST("/add-shoe", controllers.AddShoe)

	r := e.Group("/auth")
	config := middleware.JWTConfig{
		Claims:     &models.JwtCustomClaims{},
		SigningKey: []byte("secret"),
	}
	r.Use(middleware.JWTWithConfig(config))

	r.GET("/user", controllers.GetUser)

	r.PUT("/fill-profile", controllers.FillUserProfile)
	r.PUT("/fill-pin", controllers.FillUserPin)
	r.PUT("/update-photo", controllers.UpdatePhoto)
	r.PUT("/update-profile", controllers.UpdateProfile)

	r.POST("/add-card", controllers.AddCard)
	r.GET("/get-all-card", controllers.GetAllCard)
	r.GET("/get-default-card", controllers.GetDefaultCard)
	r.PUT("/change-default-card/:id", controllers.ChangeDefaultCard)

	r.POST("/add-address", controllers.AddAddress)
	r.GET("/get-all-address", controllers.GetAllAddress)
	r.GET("/get-default-address", controllers.GetDefaultAddress)
	r.PUT("/change-default-address/:id", controllers.ChangeDefaultAddress)
	r.PUT("/update-address/:id", controllers.UpdateAddress)

	r.GET("/get-all-popular-shoes", controllers.GetAllPopularShoes)
	r.GET("/get-all-brand-shoes/:brand", controllers.GetAllBrandShoes)
	r.GET("/get-all-shoes-search/:title", controllers.GetAllShoesSearch)
	r.GET("/get-shoe/:id", controllers.GetShoe)

	r.POST("/add-to-favorite/:shoe_id", controllers.AddToFavorite)
	r.DELETE("/delete-from-favorite/:favorite_id", controllers.DeleteFromFavorite)
	r.GET("/get-favorite/:shoe_id", controllers.GetFavorite)
	r.GET("/get-all-favorite-shoes", controllers.GetAllFavoriteShoes)
	r.GET("/get-all-favorite-shoes-by-brand/:brand", controllers.GetAllFavoriteShoesByBrand)

	r.POST("/add-to-cart/:shoe_id", controllers.AddToCart)
	r.GET("/get-all-carts", controllers.GetAllCarts)
	r.DELETE("/delete-cart/:id", controllers.DeleteCart)
	r.PUT("/update-qty-cart/:id", controllers.UpdateQtyCart)

	r.POST("/add-to-order", controllers.AddToOrder)
	r.GET("/get-all-order", controllers.GetAllOrder)

	r.POST("/add-review", controllers.AddReview)
	r.GET("/get-all-review/:shoe_id", controllers.GetAllReview)
	r.GET("/get-all-review/:shoe_id/:rating", controllers.GetAllReviewByRating)

	r.POST("/add-to-transaction", controllers.AddToTransaction)
	r.GET("/get-all-transaction", controllers.GetAllTransaction)

	return e
}
