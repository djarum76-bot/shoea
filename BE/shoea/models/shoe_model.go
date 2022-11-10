package models

import (
	"io"
	"mime/multipart"
	"net/http"
	"os"
	"shoea/db"

	"github.com/lib/pq"
)

func AddShoe(brand string, image *multipart.FileHeader, title string, description string, size []int, color []string, price int) (Response, error) {
	var res Response
	var err error

	con := db.CreateCon()

	sqlStatement := "INSERT INTO shoes (brand, image, title, sold, rating, review, description, size, color, price) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)"

	src, err := image.Open()
	if err != nil {
		return res, err
	}
	defer src.Close()

	imageURL := "image/" + image.Filename

	dst, err := os.Create(imageURL)
	if err != nil {
		return res, err
	}
	defer dst.Close()

	if _, err = io.Copy(dst, src); err != nil {
		return res, err
	}

	_, err = con.Exec(sqlStatement, brand, imageURL, title, 0, 0.0, 0, description, pq.Array(size), pq.Array(color), price)
	if err != nil {
		return res, err
	}

	res.Status = http.StatusOK
	res.Message = "Success Add Shoe"
	res.Data = nil

	return res, nil
}

func GetAllPopularShoes() ([]Shoe, error) {
	var shoe Shoe
	arrShoe := []Shoe{}
	var err error

	con := db.CreateCon()

	sqlStatement := "SELECT * FROM shoes ORDER BY rating DESC LIMIT 10"

	rows, err := con.Query(sqlStatement)
	if err != nil {
		return arrShoe, err
	}
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&shoe.ID, &shoe.Brand, &shoe.Image, &shoe.Title, &shoe.Sold, &shoe.Rating, &shoe.Review, &shoe.Description, pq.Array(&shoe.Sizes), pq.Array(&shoe.Colors), &shoe.Price)
		if err != nil {
			return arrShoe, err
		}

		arrShoe = append(arrShoe, shoe)
	}

	return arrShoe, nil
}

func GetAllBrandShoes(brand string) ([]Shoe, error) {
	var shoe Shoe
	arrShoe := []Shoe{}
	var err error

	con := db.CreateCon()

	sqlStatement := "SELECT * FROM shoes WHERE brand = ($1) ORDER BY rating"

	rows, err := con.Query(sqlStatement, brand)
	if err != nil {
		return arrShoe, err
	}
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&shoe.ID, &shoe.Brand, &shoe.Image, &shoe.Title, &shoe.Sold, &shoe.Rating, &shoe.Review, &shoe.Description, pq.Array(&shoe.Sizes), pq.Array(&shoe.Colors), &shoe.Price)
		if err != nil {
			return arrShoe, err
		}

		arrShoe = append(arrShoe, shoe)
	}

	return arrShoe, nil
}

func GetAllShoesSearch(title string) ([]Shoe, error) {
	var shoe Shoe
	arrShoe := []Shoe{}
	var err error

	con := db.CreateCon()

	sqlStatement := "SELECT * FROM shoes WHERE LOWER(shoes.title) LIKE " + "'%" + title + "%'"

	rows, err := con.Query(sqlStatement)
	if err != nil {
		return arrShoe, err
	}
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&shoe.ID, &shoe.Brand, &shoe.Image, &shoe.Title, &shoe.Sold, &shoe.Rating, &shoe.Review, &shoe.Description, pq.Array(&shoe.Sizes), pq.Array(&shoe.Colors), &shoe.Price)
		if err != nil {
			return arrShoe, err
		}

		arrShoe = append(arrShoe, shoe)
	}

	return arrShoe, nil
}

func GetShoe(ID string) (Shoe, error) {
	var shoe Shoe
	var err error

	con := db.CreateCon()

	sqlStatement := "SELECT * FROM shoes WHERE id = ($1)"

	err = con.QueryRow(sqlStatement, ID).Scan(&shoe.ID, &shoe.Brand, &shoe.Image, &shoe.Title, &shoe.Sold, &shoe.Rating, &shoe.Review, &shoe.Description, pq.Array(&shoe.Sizes), pq.Array(&shoe.Colors), &shoe.Price)
	if err != nil {
		return shoe, err
	}

	return shoe, nil
}
