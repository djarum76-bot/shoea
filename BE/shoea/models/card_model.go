package models

import (
	"net/http"
	"shoea/db"
)

func AddCard(userID int, bankName string, number string, expired string, cvv string, holder string) (Response, error) {
	var res Response
	var err error

	con := db.CreateCon()

	sqlStatement := "INSERT INTO cards (user_id, bank_name, number, expired_date, cvv, card_holder, is_default) VALUES ($1, $2, $3, $4, $5, $6, $7)"

	arrCard, err := GetAllCard(userID)
	if err != nil {
		return res, err
	}

	if len(arrCard) == 0 {
		_, err = con.Exec(sqlStatement, userID, bankName, number, expired, cvv, holder, true)
		if err != nil {
			return res, err
		}
	} else {
		_, err = con.Exec(sqlStatement, userID, bankName, number, expired, cvv, holder, false)
		if err != nil {
			return res, err
		}
	}

	res.Status = http.StatusOK
	res.Message = "Success Add Card"
	res.Data = nil

	return res, nil
}

func GetAllCard(userID int) ([]Card, error) {
	var err error
	var card Card
	arrCard := []Card{}

	con := db.CreateCon()

	sqlStatement := "SELECT * FROM cards WHERE user_id = ($1) ORDER BY is_default DESC"

	rows, err := con.Query(sqlStatement, userID)
	if err != nil {
		return arrCard, err
	}
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&card.ID, &card.UserID, &card.BankName, &card.Number, &card.ExpiredDate, &card.Cvv, &card.CardHolder, &card.IsDefault)
		if err != nil {
			return arrCard, err
		}

		arrCard = append(arrCard, card)
	}

	return arrCard, nil
}

func GetDefaultCard(userID int) (Card, error) {
	var card Card
	var err error

	con := db.CreateCon()

	sqlStatement := "SELECT * FROM cards WHERE user_id = ($1) AND is_default = ($2)"

	err = con.QueryRow(sqlStatement, userID, true).Scan(&card.ID, &card.UserID, &card.BankName, &card.Number, &card.ExpiredDate, &card.Cvv, &card.CardHolder, &card.IsDefault)
	if err != nil {
		return card, err
	}

	return card, nil
}

func ChangeDefaultCard(userID int, ID string) (Response, error) {
	var res Response
	var err error

	con := db.CreateCon()

	sqlStatement1 := "UPDATE cards SET is_default = ($1) WHERE user_id = ($2) AND is_default = ($3)"
	sqlStatement2 := "UPDATE cards SET is_default = ($1) WHERE id = ($2) AND user_id = ($3)"

	_, err = con.Exec(sqlStatement1, false, userID, true)
	if err != nil {
		return res, err
	}

	_, err = con.Exec(sqlStatement2, true, ID, userID)
	if err != nil {
		return res, err
	}

	return res, nil
}
