package models

import (
	"net/http"
	"shoea/db"
)

func AddToTransaction(transactionID int, userID int, shoeID int, color string, size int, qty int, price int, payment string, createdAt string) (Response, error) {
	var res Response
	var err error

	con := db.CreateCon()

	sqlStatement := "INSERT INTO transactions (transaction_id, user_id, shoe_id, color, size, qty, price, payment, created_at) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)"

	_, err = con.Exec(sqlStatement, transactionID, userID, shoeID, color, size, qty, price, payment, createdAt)
	if err != nil {
		return res, err
	}

	res.Status = http.StatusOK
	res.Message = "Success Add To Transaction"
	res.Data = nil

	return res, nil
}

func GetAllTransaction(userID int) ([]Transaction, error) {
	var transaction Transaction
	arrTransaction := []Transaction{}
	var shoe Shoe

	con := db.CreateCon()

	sqlStatement1 := "SELECT * FROM transactions WHERE user_id = ($1) ORDER BY created_at DESC"
	sqlStatement2 := "SELECT image, title FROM shoes WHERE id = ($1)"

	rows, err := con.Query(sqlStatement1, userID)
	if err != nil {
		return arrTransaction, err
	}
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&transaction.ID, &transaction.TransactionID, &transaction.UserID, &transaction.ShoeID, &transaction.Color, &transaction.Size, &transaction.Qty, &transaction.Price, &transaction.Payment, &transaction.CreatedAt)
		if err != nil {
			return arrTransaction, err
		}

		err = con.QueryRow(sqlStatement2, transaction.ShoeID).Scan(&shoe.Image, &shoe.Title)
		if err != nil {
			return arrTransaction, err
		}

		transaction.Shoe = shoe

		arrTransaction = append(arrTransaction, transaction)
	}

	return arrTransaction, nil
}
