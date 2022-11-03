package models

import (
	"database/sql"
	"net/http"
	"shoea/db"
)

func AddToCart(userID int, shoeID int, color string, size int, qty int) (Response, error) {
	var res Response
	var err error
	var ID int

	con := db.CreateCon()

	sqlStatement1 := "SELECT id FROM carts WHERE user_id = ($1) AND shoe_id = ($2)"
	sqlStatement2 := "INSERT INTO carts (user_id, shoe_id, color, size, qty) VALUES ($1, $2, $3, $4, $5)"
	sqlStatement3 := "UPDATE carts SET color = ($1), size = ($2), qty = ($3) WHERE id = ($4)"

	err = con.QueryRow(sqlStatement1, userID, shoeID).Scan(&ID)
	if err == sql.ErrNoRows {
		_, err = con.Exec(sqlStatement2, userID, shoeID, color, size, qty)
		if err != nil {
			return res, err
		}
	} else {
		_, err = con.Exec(sqlStatement3, color, size, qty, ID)
		if err != nil {
			return res, err
		}
	}

	res.Status = http.StatusOK
	res.Message = "Success Add To Cart"
	res.Data = nil

	return res, nil
}

func GetAllCarts(userID int) ([]Cart, error) {
	var cart Cart
	arrCart := []Cart{}
	var err error

	con := db.CreateCon()

	sqlStatement1 := "SELECT * FROM carts WHERE user_id = ($1) ORDER BY id"
	sqlStatement2 := "SELECT image, title, price FROM shoes WHERE id = ($1)"

	rows, err := con.Query(sqlStatement1, userID)
	if err != nil {
		return arrCart, err
	}
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&cart.ID, &cart.UserID, &cart.ShoeID, &cart.Color, &cart.Size, &cart.Qty)
		if err != nil {
			return arrCart, err
		}

		err = con.QueryRow(sqlStatement2, cart.ShoeID).Scan(&cart.Image, &cart.Title, &cart.Price)
		if err != nil {
			return arrCart, err
		}

		arrCart = append(arrCart, cart)
	}

	return arrCart, nil
}

func DeleteCart(ID int) (Response, error) {
	var res Response
	var err error

	con := db.CreateCon()

	sqlStatement := "DELETE FROM carts WHERE id = ($1)"

	_, err = con.Exec(sqlStatement, ID)
	if err != nil {
		return res, err
	}

	return res, nil
}

func UpdateQtyCart(ID int, qty int) (Response, error) {
	var res Response
	var err error

	con := db.CreateCon()

	sqlStatement := "UPDATE carts SET qty = ($1) WHERE id = ($2)"

	_, err = con.Exec(sqlStatement, qty, ID)
	if err != nil {
		return res, err
	}

	return res, nil
}
