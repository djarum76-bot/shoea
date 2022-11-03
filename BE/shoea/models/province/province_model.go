package province

import "encoding/json"

func UnmarshalProvinceModel(data []byte) (ProvinceModel, error) {
	var r ProvinceModel
	err := json.Unmarshal(data, &r)
	return r, err
}

func (r *ProvinceModel) Marshal() ([]byte, error) {
	return json.Marshal(r)
}

type ProvinceModel struct {
	Rajaongkir Rajaongkir `json:"rajaongkir"`
}

type Rajaongkir struct {
	Query   Query   `json:"query"`
	Status  Status  `json:"status"`
	Results Results `json:"results"`
}

type Query struct {
	ID string `json:"id"`
}

type Results struct {
	ProvinceID string `json:"province_id"`
	Province   string `json:"province"`
}

type Status struct {
	Code        int64  `json:"code"`
	Description string `json:"description"`
}
