package main

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"os"
	"strconv"
	"time"

	kafkaAvro "github.com/dangkaka/go-kafka-avro"
)

func main() {
	kafkaUrl := os.Getenv("KAFKA_URL")
	schemaRegistryUrl := os.Getenv("SCHEMA_REGISTRY_URL")
	myTopic := os.Getenv("KAFKA_TOPIC")

	// apache avro schema
	dogSchema := `{
			"name": "Dog",
			"type": "record",
			"fields": [
				{
					"name": "Name",
					"type": "string"
				},
				{
					"name": "Breed",
					"type": "string"
				},
				{
					"name": "BornAt",
					"type": "string"
				},
				{
					"name": "Age",
					"type": "int"
				}
			]
		}`

	// initialise apache avro producer
	avroProducer, _ := kafkaAvro.NewAvroProducer([]string{kafkaUrl}, []string{schemaRegistryUrl})

	// initialse timer
	ticker := time.NewTicker(2 * time.Second)

	go startTimeLimit(ticker)

	count := 0

	breeds := []string{"Husky", "Labrador", "German Shepherd", "Shiba Inu", "Poodle"}
	// generate dogs
	for time := range ticker.C {
		// avro schema validation fails on dog 5
		if count == 5 {
			error := avroProducer.Add(myTopic, dogSchema, []byte("key"), []byte("Dog5"))

			if error != nil {
				fmt.Println("producer err: ", error)
			}
		} else {
			dog := Dog{
				Name:   fmt.Sprintf("Dog%v", count),
				Breed:  breeds[rand.Intn(len(breeds))],
				BornAt: time.Local().String(),
				Age:    0,
			}
			msgJson, _ := json.Marshal(dog)

			// send serialized msg to topic
			avroProducer.Add(myTopic, dogSchema, []byte("key"), msgJson)
		}

		count++
	}

	avroProducer.Close()
}

func startTimeLimit(ticker *time.Ticker) {
	lim, _ := strconv.Atoi(os.Getenv("APP_LIFETIME"))

	time.Sleep(time.Second * time.Duration(lim))

	ticker.Stop()
}

type Dog struct {
	Name   string
	Breed  string
	BornAt string
	Age    int
}
