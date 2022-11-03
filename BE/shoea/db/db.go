package db

import (
	"database/sql"
	"fmt"
	"shoea/config"

	_ "github.com/lib/pq"
)

var db *sql.DB
var err error

func Init() {
	conf := config.GetConfig()

	psqlInfo := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable", conf.DB_HOST, conf.DB_PORT, conf.DB_USER, conf.DB_PASS, conf.DB_NAME)

	db, err = sql.Open("postgres", psqlInfo)
	if err != nil {
		panic(err.Error())
	}

	err = db.Ping()
	if err != nil {
		panic(err.Error())
	}
}

func CreateCon() *sql.DB {
	return db
}
