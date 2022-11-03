package city

import "encoding/json"

func UnmarshalCityModel(data []byte) (CityModel, error) {
	var r CityModel
	err := json.Unmarshal(data, &r)
	return r, err
}

func (r *CityModel) Marshal() ([]byte, error) {
	return json.Marshal(r)
}

type CityModel struct {
	Rajaongkir Rajaongkir `json:"rajaongkir"`
}

type Rajaongkir struct {
	Query   Query   `json:"query"`
	Status  Status  `json:"status"`
	Results Results `json:"results"`
}

type Query struct {
	ID       string `json:"id"`
	Province string `json:"province"`
}

type Results struct {
	CityID     string `json:"city_id"`
	ProvinceID string `json:"province_id"`
	Province   string `json:"province"`
	Type       string `json:"type"`
	CityName   string `json:"city_name"`
	PostalCode string `json:"postal_code"`
}

type Status struct {
	Code        int64  `json:"code"`
	Description string `json:"description"`
}
