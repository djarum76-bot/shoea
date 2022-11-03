package models

import (
	"database/sql"
	"io"
	"mime/multipart"
	"net/http"
	"os"
	"shoea/db"
)

func GetUser(id string) (User, error) {
	var user User
	var err error

	con := db.CreateCon()

	sqlStatement := "SELECT id, email, picture, name, date, phone, gender, pin FROM users WHERE id = ($1)"

	err = con.QueryRow(sqlStatement, id).Scan(&user.ID, &user.Email, &user.Picture, &user.Name, &user.Date, &user.Phone, &user.Gender, &user.Pin)
	if err == sql.ErrNoRows {
		return user, err
	}
	if err != nil {
		return user, err
	}

	return user, nil
}

func FillUserProfile(id string, picture *multipart.FileHeader, name string, date string, phone string, gender string) (User, error) {
	var user User
	var err error

	con := db.CreateCon()

	sqlStatement := "UPDATE users SET picture = ($1), name = ($2), date = ($3), phone = ($4), gender = ($5) WHERE id = ($6)"

	src, err := picture.Open()
	if err != nil {
		return user, err
	}
	defer src.Close()

	pictureURL := "profile/" + picture.Filename

	dst, err := os.Create(pictureURL)
	if err != nil {
		return user, err
	}
	defer dst.Close()

	if _, err = io.Copy(dst, src); err != nil {
		return user, err
	}

	_, err = con.Exec(sqlStatement, pictureURL, name, date, phone, gender, id)
	if err != nil {
		return user, err
	}

	user, err = GetUser(id)
	if err != nil {
		return user, err
	}

	return user, nil
}

func FillUserPin(id string, pin string) (User, error) {
	var user User
	var err error

	con := db.CreateCon()

	sqlStatement := "UPDATE users SET pin = ($1) WHERE id = ($2)"

	_, err = con.Exec(sqlStatement, pin, id)
	if err != nil {
		return user, err
	}

	user, err = GetUser(id)
	if err != nil {
		return user, err
	}

	return user, nil
}

func UpdatePhoto(id int, picture *multipart.FileHeader) (Response, error) {
	var res Response
	var err error

	con := db.CreateCon()

	sqlStatement := "UPDATE users SET picture = ($1) WHERE id = ($2)"

	src, err := picture.Open()
	if err != nil {
		return res, err
	}
	defer src.Close()

	pictureURL := "profile/" + picture.Filename

	dst, err := os.Create(pictureURL)
	if err != nil {
		return res, err
	}
	defer dst.Close()

	if _, err = io.Copy(dst, src); err != nil {
		return res, err
	}

	_, err = con.Exec(sqlStatement, pictureURL, id)
	if err != nil {
		return res, err
	}

	res.Status = http.StatusOK
	res.Message = "Success Update"
	res.Data = nil

	return res, nil
}

func UpdateProfile(id int, name string, date string, phone string, gender string) (Response, error) {
	var res Response
	var err error

	con := db.CreateCon()

	sqlStatement := "UPDATE users SET name = ($1), date = ($2), phone = ($3), gender = ($4) WHERE id = ($5)"

	_, err = con.Exec(sqlStatement, name, date, phone, gender, id)
	if err != nil {
		return res, err
	}

	res.Status = http.StatusOK
	res.Message = "Update Success"
	res.Data = nil

	return res, nil
}
