package main

import (
	"shoea/db"
	"shoea/routes"
)

func main() {
	db.Init()

	e := routes.Init()

	e.Logger.Fatal(e.Start(":8080"))
}
