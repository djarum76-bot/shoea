package models

import (
	"database/sql"
	"net/http"
	"shoea/db"

	"github.com/lib/pq"
)

func AddToFavorite(userID int, shoeID int) (Response, error) {
	var res Response
	var err error

	con := db.CreateCon()

	sqlStatement := "INSERT INTO favorites (user_id, shoe_id) VALUES ($1, $2)"

	_, err = con.Exec(sqlStatement, userID, shoeID)
	if err != nil {
		return res, err
	}

	res.Status = http.StatusOK
	res.Message = "Success Add To Favorite"
	res.Data = nil

	return res, nil
}

func DeleteFromFavorite(favoriteID int) (Response, error) {
	var res Response
	var err error

	con := db.CreateCon()

	sqlStatement := "DELETE FROM favorites WHERE id = ($1)"

	_, err = con.Exec(sqlStatement, favoriteID)
	if err != nil {
		return res, err
	}

	res.Status = http.StatusOK
	res.Message = "Delete From Favorite"
	res.Data = nil

	return res, nil
}

func GetFavorite(shoeID int, userID int) (Favorite, error) {
	var favorite Favorite
	var err error

	con := db.CreateCon()

	sqlStatement := "SELECT * FROM favorites WHERE shoe_id = ($1) AND user_id = ($2)"

	err = con.QueryRow(sqlStatement, shoeID, userID).Scan(&favorite.ID, &favorite.UserID, &favorite.ShoeID)
	if err != nil {
		if err == sql.ErrNoRows {
			return favorite, nil
		} else {
			return favorite, err
		}
	}

	return favorite, nil
}

func GetAllFavoriteShoes(userID int) ([]Shoe, error) {
	var shoe Shoe
	arrShoe := []Shoe{}
	var err error
	var shoeID int

	con := db.CreateCon()

	sqlStatement1 := "SELECT shoe_id FROM favorites WHERE user_id = ($1)"
	sqlStatement2 := "SELECT * FROM shoes WHERE id = ($1)"

	rows1, err := con.Query(sqlStatement1, userID)
	if err != nil {
		return arrShoe, err
	}
	defer rows1.Close()

	for rows1.Next() {
		err = rows1.Scan(&shoeID)
		if err != nil {
			return arrShoe, err
		}

		rows2, err := con.Query(sqlStatement2, shoeID)
		if err != nil {
			return arrShoe, err
		}
		defer rows2.Close()

		for rows2.Next() {
			err = rows2.Scan(&shoe.ID, &shoe.Brand, &shoe.Image, &shoe.Title, &shoe.Sold, &shoe.Rating, &shoe.Review, &shoe.Description, pq.Array(&shoe.Sizes), pq.Array(&shoe.Colors), &shoe.Price)
			if err != nil {
				return arrShoe, err
			}

			arrShoe = append(arrShoe, shoe)
		}
	}

	return arrShoe, nil
}

func GetAllFavoriteShoesByBrand(userID int, brand string) ([]Shoe, error) {
	var shoe Shoe
	arrShoe := []Shoe{}
	var err error
	var shoeID int

	con := db.CreateCon()

	sqlStatement1 := "SELECT shoe_id FROM favorites WHERE user_id = ($1)"
	sqlStatement2 := "SELECT * FROM shoes WHERE id = ($1) AND brand = ($2)"

	rows1, err := con.Query(sqlStatement1, userID)
	if err != nil {
		return arrShoe, err
	}
	defer rows1.Close()

	for rows1.Next() {
		err = rows1.Scan(&shoeID)
		if err != nil {
			return arrShoe, err
		}

		rows2, err := con.Query(sqlStatement2, shoeID, brand)
		if err != nil {
			return arrShoe, err
		}
		defer rows2.Close()

		for rows2.Next() {
			err = rows2.Scan(&shoe.ID, &shoe.Brand, &shoe.Image, &shoe.Title, &shoe.Sold, &shoe.Rating, &shoe.Review, &shoe.Description, pq.Array(&shoe.Sizes), pq.Array(&shoe.Colors), &shoe.Price)
			if err != nil {
				return arrShoe, err
			}

			arrShoe = append(arrShoe, shoe)
		}
	}

	return arrShoe, nil
}
