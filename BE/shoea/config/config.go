package config

import "github.com/tkanos/gonfig"

type Configuration struct {
	DB_USER string
	DB_PASS string
	DB_NAME string
	DB_HOST string
	DB_PORT string
}

func GetConfig() Configuration {
	conf := Configuration{}
	err := gonfig.GetConf("config/config.json", &conf)
	if err != nil {
		panic(err.Error())
	}

	return conf
}
