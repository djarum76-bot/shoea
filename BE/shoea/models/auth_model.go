package models

import (
	"database/sql"
	"net/http"
	"shoea/db"
	"shoea/helper"
	"time"

	"github.com/golang-jwt/jwt"
)

func Register(email string, password string) (AuthResponse, error) {
	var res AuthResponse
	var err error
	var ID int
	var user User

	con := db.CreateCon()

	sqlStatement := "INSERT INTO users (email, password) VALUES ($1, $2) RETURNING id"

	err = con.QueryRow(sqlStatement, email, password).Scan(&ID)
	if err != nil {
		return res, err
	}

	claims := &JwtCustomClaims{
		ID,
		email,
		jwt.StandardClaims{
			ExpiresAt: time.Now().Add(time.Hour * 720).Unix(),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	t, err := token.SignedString([]byte("secret"))
	if err != nil {
		return res, err
	}

	user.ID = ID
	user.Email = email
	user.Picture = sql.NullString{
		String: "",
		Valid:  false,
	}
	user.Name = sql.NullString{
		String: "",
		Valid:  false,
	}
	user.Date = sql.NullString{
		String: "",
		Valid:  false,
	}
	user.Phone = sql.NullString{
		String: "",
		Valid:  false,
	}
	user.Gender = sql.NullString{
		String: "",
		Valid:  false,
	}
	user.Pin = sql.NullString{
		String: "",
		Valid:  false,
	}

	res.Status = http.StatusOK
	res.Message = "Register Success"
	res.Token = t

	return res, nil
}

func Login(email string, password string) (AuthResponse, error) {
	var res AuthResponse
	var err error
	var pwdHash string
	var user User

	con := db.CreateCon()

	sqlStatement := "SELECT * FROM users WHERE email = ($1)"

	err = con.QueryRow(sqlStatement, email).Scan(&user.ID, &user.Email, &pwdHash, &user.Picture, &user.Name, &user.Date, &user.Phone, &user.Gender, &user.Pin)
	if err == sql.ErrNoRows {
		return res, err
	}
	if err != nil {
		return res, err
	}

	match, err := helper.CheckPasswordHash(pwdHash, password)
	if !match {
		return res, err
	}

	claims := &JwtCustomClaims{
		user.ID,
		user.Email,
		jwt.StandardClaims{
			ExpiresAt: time.Now().Add(time.Hour * 720).Unix(),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	t, err := token.SignedString([]byte("secret"))
	if err != nil {
		return res, err
	}

	res.Status = http.StatusOK
	res.Message = "Login Success"
	res.Data = user
	res.Token = t

	return res, nil
}
