package models

import (
	"database/sql"
	"shoea/models/city"
	"shoea/models/province"

	"github.com/golang-jwt/jwt"
)

type AuthResponse struct {
	Status  int         `json:"status"`
	Message string      `json:"message"`
	Data    interface{} `json:"data"`
	Token   string      `json:"token"`
}

type Response struct {
	Status  int         `json:"status"`
	Message string      `json:"message"`
	Data    interface{} `json:"data"`
}

type User struct {
	ID      int            `json:"id"`
	Email   string         `json:"email"`
	Picture sql.NullString `json:"picture"`
	Name    sql.NullString `json:"name"`
	Date    sql.NullString `json:"date"`
	Phone   sql.NullString `json:"phone"`
	Gender  sql.NullString `json:"gender"`
	Pin     sql.NullString `json:"pin"`
}

type JwtCustomClaims struct {
	ID    int    `json:"id"`
	Email string `json:"email"`
	jwt.StandardClaims
}

type Card struct {
	ID          int    `json:"id"`
	UserID      int    `json:"user_id"`
	BankName    string `json:"bank_name"`
	Number      string `json:"number"`
	ExpiredDate string `json:"expired_date"`
	Cvv         string `json:"cvv"`
	CardHolder  string `json:"card_holder"`
	IsDefault   bool   `json:"is_default"`
}

type Address struct {
	ID            int              `json:"id"`
	UserID        int              `json:"user_id"`
	Lat           float64          `json:"lat"`
	Lng           float64          `json:"lng"`
	AddressName   string           `json:"address_name"`
	ProvinceData  province.Results `json:"province"`
	CityData      city.Results     `json:"city"`
	AddressDetail string           `json:"address_detail"`
	IsDefault     bool             `json:"is_default"`
}

type Shoe struct {
	ID          int             `json:"id"`
	Brand       string          `json:"brand"`
	Image       string          `json:"image"`
	Title       string          `json:"title"`
	Sold        int             `json:"sold"`
	Rating      float32         `json:"rating"`
	Review      int             `json:"review"`
	Description string          `json:"description"`
	Sizes       []sql.NullInt64 `json:"sizes"`
	Colors      []string        `json:"colors"`
	Price       int             `json:"price"`
}

type Cart struct {
	ID     int    `json:"id"`
	UserID int    `json:"user_id"`
	ShoeID int    `json:"shoe_id"`
	Image  string `json:"image"`
	Title  string `json:"title"`
	Color  string `json:"color"`
	Size   int    `json:"size"`
	Price  int    `json:"price"`
	Qty    int    `json:"qty"`
}

type Order struct {
	ID              int          `json:"id"`
	UserID          int          `json:"user_id"`
	ShoeID          int          `json:"shoe_id"`
	OriginCity      city.Results `json:"origin_city"`
	DestinationCity city.Results `json:"destination_city"`
	Color           string       `json:"color"`
	Size            int          `json:"size"`
	Qty             int          `json:"qty"`
	Price           int          `json:"price"`
	Status          string       `json:"status"`
	IsReviewed      bool         `json:"is_reviewed"`
	Etd             string       `json:"etd"`
	Shoe            Shoe         `json:"shoe"`
	CreatedAt       string       `json:"created_at"`
}

type Transaction struct {
	ID            int    `json:"id"`
	TransactionID int    `json:"transaction_id"`
	UserID        int    `json:"user_id"`
	ShoeID        int    `json:"shoe_id"`
	Color         string `json:"color"`
	Size          int    `json:"size"`
	Qty           int    `json:"qty"`
	Price         int    `json:"price"`
	Shoe          Shoe   `json:"shoe"`
	Payment       string `json:"payment"`
	CreatedAt     string `json:"created_at"`
}

type Review struct {
	ID        int     `json:"id"`
	User      User    `json:"user"`
	OrderID   int     `json:"order_id"`
	ShoeID    int     `json:"shoe_id"`
	Rating    float32 `json:"rating"`
	Comment   string  `json:"comment"`
	CreatedAt string  `json:"created_at"`
}

type Favorite struct {
	ID     int `json:"id"`
	UserID int `json:"user_id"`
	ShoeID int `json:"shoe_id"`
}
