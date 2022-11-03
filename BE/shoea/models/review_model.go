package models

import (
	"net/http"
	"shoea/db"
)

func AddReview(userID int, orderID int, shoeID int, rating float32, comment string, createdAt string) (Response, error) {
	var res Response
	var err error
	var oldReview int
	var shoeRating float32

	con := db.CreateCon()

	sqlStatement1 := "INSERT INTO reviews (user_id, order_id, shoe_id, rating, comment, created_at) VALUES ($1, $2, $3, $4, $5, $6)"
	sqlStatement2 := "UPDATE orders SET is_reviewed = ($1) WHERE id = ($2)"
	sqlStatement3 := "SELECT review, rating FROM shoes WHERE id = ($1)"
	sqlStatement4 := "UPDATE shoes SET review = ($1), rating = ($2) WHERE id = ($3)"

	_, err = con.Exec(sqlStatement1, userID, orderID, shoeID, rating, comment, createdAt)
	if err != nil {
		return res, err
	}

	_, err = con.Exec(sqlStatement2, true, orderID)
	if err != nil {
		return res, err
	}

	err = con.QueryRow(sqlStatement3, shoeID).Scan(&oldReview, &shoeRating)
	if err != nil {
		return res, err
	}

	oldTotalRating := shoeRating * float32(oldReview)
	newTotalRating := oldTotalRating + rating
	newReview := oldReview + 1
	newAverageRating := newTotalRating / float32(newReview)
	_, err = con.Exec(sqlStatement4, newReview, newAverageRating, shoeID)
	if err != nil {
		return res, err
	}

	res.Status = http.StatusOK
	res.Message = "Success Add Review"
	res.Data = nil

	return res, nil
}

func GetAllReview(shoeID int) ([]Review, error) {
	var review Review
	arrReview := []Review{}
	var err error
	var userID string
	var user User

	con := db.CreateCon()

	sqlStatement1 := "SELECT * FROM reviews WHERE shoe_id = ($1)"
	sqlStatement2 := "SELECT picture, name FROM users WHERE id = ($1)"

	rows, err := con.Query(sqlStatement1, shoeID)
	if err != nil {
		return arrReview, err
	}
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&review.ID, &userID, &review.OrderID, &review.ShoeID, &review.Rating, &review.Comment, &review.CreatedAt)
		if err != nil {
			return arrReview, err
		}

		err = con.QueryRow(sqlStatement2, userID).Scan(&user.Picture, &user.Name)
		if err != nil {
			return arrReview, err
		}

		review.User = user

		arrReview = append(arrReview, review)
	}

	return arrReview, nil
}

func GetAllReviewByRating(shoeID int, rating float32) ([]Review, error) {
	var review Review
	arrReview := []Review{}
	var err error
	var userID string
	var user User

	con := db.CreateCon()

	sqlStatement1 := "SELECT * FROM reviews WHERE shoe_id = ($1) and rating = ($2)"
	sqlStatement2 := "SELECT picture, name FROM users WHERE id = ($1)"

	rows, err := con.Query(sqlStatement1, shoeID, rating)
	if err != nil {
		return arrReview, err
	}
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&review.ID, &userID, &review.OrderID, &review.ShoeID, &review.Rating, &review.Comment, &review.CreatedAt)
		if err != nil {
			return arrReview, err
		}

		err = con.QueryRow(sqlStatement2, userID).Scan(&user.Picture, &user.Name)
		if err != nil {
			return arrReview, err
		}

		review.User = user

		arrReview = append(arrReview, review)
	}

	return arrReview, nil
}
