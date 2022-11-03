package models

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"shoea/db"
	"shoea/models/city"
)

func AddToOrder(userID int, shoeID int, originCityID int, destinationCityID int, price int, etd string, createdAt string) (Response, error) {
	var res Response
	var err error
	var cartID int
	var cartColor string
	var cartSize int
	var cartQty int
	var shoeSold int

	con := db.CreateCon()

	sqlStatement1 := "SELECT id, color, size, qty FROM carts WHERE user_id = ($1) AND shoe_id = ($2)"
	sqlStatement2 := "DELETE FROM carts WHERE id = ($1)"
	sqlStatement3 := "INSERT INTO orders (user_id, shoe_id, origin_city_id, destination_city_id, color, size, qty, price, status, is_reviewed, etd, created_at) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)"
	sqlStatement4 := "SELECT sold FROM shoes WHERE id = ($1)"
	sqlStatement5 := "UPDATE shoes SET sold = ($1) WHERE id = ($2)"

	err = con.QueryRow(sqlStatement1, userID, shoeID).Scan(&cartID, &cartColor, &cartSize, &cartQty)
	if err != nil {
		return res, err
	}

	_, err = con.Exec(sqlStatement2, cartID)
	if err != nil {
		return res, err
	}

	_, err = con.Exec(sqlStatement3, userID, shoeID, originCityID, destinationCityID, cartColor, cartSize, cartQty, price, "Active", false, etd, createdAt)
	if err != nil {
		return res, err
	}

	err = con.QueryRow(sqlStatement4, shoeID).Scan(&shoeSold)
	if err != nil {
		return res, err
	}

	sold := shoeSold + cartQty
	_, err = con.Exec(sqlStatement5, sold, shoeID)
	if err != nil {
		return res, err
	}

	res.Status = http.StatusOK
	res.Message = "Success Add To Order"
	res.Data = nil

	return res, nil
}

func GetAllOrder(userID int) ([]Order, error) {
	var order Order
	arrOrder := []Order{}
	var originCityID int
	var destinationCityID int
	var shoe Shoe

	con := db.CreateCon()
	client := http.Client{}

	sqlStatement1 := "SELECT * FROM orders WHERE user_id = ($1) ORDER BY created_at DESC"
	sqlStatement2 := "SELECT brand, image, title FROM shoes WHERE id = ($1)"

	rows, err := con.Query(sqlStatement1, userID)
	if err != nil {
		return arrOrder, err
	}
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&order.ID, &order.UserID, &order.ShoeID, &originCityID, &destinationCityID, &order.Color, &order.Size, &order.Qty, &order.Price, &order.Status, &order.IsReviewed, &order.Etd, &order.CreatedAt)
		if err != nil {
			return arrOrder, err
		}

		//origin
		urlOrigin := fmt.Sprintf("https://api.rajaongkir.com/starter/city?id=%d", originCityID)
		reqOrigin, err := http.NewRequest("GET", urlOrigin, nil)
		if err != nil {
			return arrOrder, err
		}
		reqOrigin.Header.Set("key", apiKey)

		respOrigin, err := client.Do(reqOrigin)
		if err != nil {
			return arrOrder, err
		}
		defer respOrigin.Body.Close()

		bodyBytesOrigin, err := ioutil.ReadAll(respOrigin.Body)
		if err != nil {
			return arrOrder, err
		}

		responseOrigin, err := city.UnmarshalCityModel(bodyBytesOrigin)
		if err != nil {
			return arrOrder, err
		}

		//destination
		urlDestination := fmt.Sprintf("https://api.rajaongkir.com/starter/city?id=%d", destinationCityID)
		reqDestination, err := http.NewRequest("GET", urlDestination, nil)
		if err != nil {
			return arrOrder, err
		}
		reqDestination.Header.Set("key", apiKey)

		respDestination, err := client.Do(reqDestination)
		if err != nil {
			return arrOrder, err
		}
		defer respDestination.Body.Close()

		bodyBytesDestination, err := ioutil.ReadAll(respDestination.Body)
		if err != nil {
			return arrOrder, err
		}

		responseDestination, err := city.UnmarshalCityModel(bodyBytesDestination)
		if err != nil {
			return arrOrder, err
		}

		//shoe
		err = con.QueryRow(sqlStatement2, order.ShoeID).Scan(&shoe.Brand, &shoe.Image, &shoe.Title)
		if err != nil {
			return arrOrder, err
		}

		order.OriginCity = responseOrigin.Rajaongkir.Results
		order.DestinationCity = responseDestination.Rajaongkir.Results
		order.Shoe = shoe

		arrOrder = append(arrOrder, order)
	}

	return arrOrder, nil
}
