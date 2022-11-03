package models

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"shoea/db"
	"shoea/models/city"
	"shoea/models/province"
)

const apiKey = "947b5da46165f5e933965eb9df850492"

func AddAddress(userID int, provinceID int, cityID int, lat float64, lng float64, addressName string, addressDetail string) (Response, error) {
	var res Response
	var err error

	con := db.CreateCon()

	sqlStatement := "INSERT INTO address (user_id, province_id, city_id, lat, lng, address_name, address_detail, is_default) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)"

	arrAddress, err := GetAllAddress(userID)
	if err != nil {
		return res, err
	}

	if len(arrAddress) == 0 {
		_, err = con.Exec(sqlStatement, userID, provinceID, cityID, lat, lng, addressName, addressDetail, true)
		if err != nil {
			return res, err
		}
	} else {
		_, err = con.Exec(sqlStatement, userID, provinceID, cityID, lat, lng, addressName, addressDetail, false)
		if err != nil {
			return res, err
		}
	}

	res.Status = http.StatusOK
	res.Message = "Success Add Address"
	res.Data = nil

	return res, nil
}

func GetAllAddress(userID int) ([]Address, error) {
	var address Address
	arrAddress := []Address{}
	var addressProvinceID int
	var addressCityID int
	var err error

	con := db.CreateCon()
	client := http.Client{}

	sqlStatement := "SELECT * FROM address WHERE user_id = ($1) ORDER BY is_default DESC"

	rows, err := con.Query(sqlStatement, userID)
	if err != nil {
		return arrAddress, err
	}
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&address.ID, &address.UserID, &addressProvinceID, &addressCityID, &address.Lat, &address.Lng, &address.AddressName, &address.AddressDetail, &address.IsDefault)
		if err != nil {
			return arrAddress, err
		}

		//province
		urlProv := fmt.Sprintf("https://api.rajaongkir.com/starter/province?id=%d", addressProvinceID)
		reqProvince, err := http.NewRequest("GET", urlProv, nil)
		if err != nil {
			return arrAddress, err
		}
		reqProvince.Header.Set("key", apiKey)

		respProvince, err := client.Do(reqProvince)
		if err != nil {
			return arrAddress, err
		}
		defer respProvince.Body.Close()

		bodyBytesProvince, err := ioutil.ReadAll(respProvince.Body)
		if err != nil {
			return arrAddress, err
		}

		responseProvince, err := province.UnmarshalProvinceModel(bodyBytesProvince)
		if err != nil {
			return arrAddress, err
		}

		//city
		urlCIty := fmt.Sprintf("https://api.rajaongkir.com/starter/city?id=%d&province=%d", addressCityID, addressProvinceID)
		reqCity, err := http.NewRequest("GET", urlCIty, nil)
		if err != nil {
			return arrAddress, err
		}
		reqCity.Header.Set("key", apiKey)

		respCity, err := client.Do(reqCity)
		if err != nil {
			return arrAddress, err
		}
		defer respCity.Body.Close()

		bodyBytesCity, err := ioutil.ReadAll(respCity.Body)
		if err != nil {
			return arrAddress, err
		}

		responceCity, err := city.UnmarshalCityModel(bodyBytesCity)
		if err != nil {
			return arrAddress, err
		}

		address.ProvinceData = responseProvince.Rajaongkir.Results
		address.CityData = responceCity.Rajaongkir.Results

		arrAddress = append(arrAddress, address)
	}

	return arrAddress, nil
}

func GetDefaultAddress(userID int) (Address, error) {
	var address Address
	var addressProvinceID int
	var addressCityID int
	var err error

	con := db.CreateCon()

	sqlStatement := "SELECT * FROM address WHERE user_id = ($1) AND is_default = ($2)"

	err = con.QueryRow(sqlStatement, userID, true).Scan(&address.ID, &address.UserID, &addressProvinceID, &addressCityID, &address.Lat, &address.Lng, &address.AddressName, &address.AddressDetail, &address.IsDefault)
	if err != nil {
		return address, err
	}

	client := http.Client{}

	//province
	urlProv := fmt.Sprintf("https://api.rajaongkir.com/starter/province?id=%d", addressProvinceID)
	reqProvince, err := http.NewRequest("GET", urlProv, nil)
	if err != nil {
		return address, err
	}
	reqProvince.Header.Set("key", apiKey)

	respProvince, err := client.Do(reqProvince)
	if err != nil {
		return address, err
	}
	defer respProvince.Body.Close()

	bodyBytesProvince, err := ioutil.ReadAll(respProvince.Body)
	if err != nil {
		return address, err
	}

	responseProvince, err := province.UnmarshalProvinceModel(bodyBytesProvince)
	if err != nil {
		return address, err
	}

	//city
	urlCIty := fmt.Sprintf("https://api.rajaongkir.com/starter/city?id=%d&province=%d", addressCityID, addressProvinceID)
	reqCity, err := http.NewRequest("GET", urlCIty, nil)
	if err != nil {
		return address, err
	}
	reqCity.Header.Set("key", apiKey)

	respCity, err := client.Do(reqCity)
	if err != nil {
		return address, err
	}
	defer respCity.Body.Close()

	bodyBytesCity, err := ioutil.ReadAll(respCity.Body)
	if err != nil {
		return address, err
	}

	responceCity, err := city.UnmarshalCityModel(bodyBytesCity)
	if err != nil {
		return address, err
	}

	address.ProvinceData = responseProvince.Rajaongkir.Results
	address.CityData = responceCity.Rajaongkir.Results

	return address, nil
}

func ChangeDefaultAddress(userID int, ID string) (Response, error) {
	var res Response
	var err error

	con := db.CreateCon()

	sqlStatement1 := "UPDATE address SET is_default = ($1) WHERE user_id = ($2) AND is_default = ($3)"
	sqlStatement2 := "UPDATE address SET is_default = ($1) WHERE id = ($2) AND user_id = ($3)"

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

func UpdateAddress(ID string, provinceID int, cityID int, addressName string, addressDetail string) (Response, error) {
	var res Response
	var err error

	con := db.CreateCon()

	sqlStatement := "UPDATE address SET province_id = ($1), city_id = ($2), address_name = ($3), address_detail = ($4) WHERE id = ($5)"

	_, err = con.Exec(sqlStatement, provinceID, cityID, addressName, addressDetail, ID)
	if err != nil {
		return res, err
	}

	return res, nil
}
