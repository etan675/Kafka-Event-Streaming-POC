
### Kafka demo - event streaming
* version 0.0.1

### What is this repository for? ###

* We want an example of how to integrate with a Kafka cluster from k8s while we develop on local machines, so we can maintain Go microservices at scale.
* This project demos through the CLI how a microservice will interact with Kafka, and how Kafka validates and consumes the messages pushed to it.
* We will spin up:
  -  a container that runs a Kafka cluster, configured to validate and process 'dog' messages.
  -  a container that runs a Go service, which publishes messages to Kafka.
* We should see that any messages that don't match the expected avro schema (dog-schema.avsc) are invalid and ignored by Kafka, while valid 'dog' messages are successfully outputed to console.

### Tech stack

* Apache Kafka
* Golang
* Docker

### How do I get set up? ###

* Have Docker installed
* Clone the repo
* In your shell, use the following make commands to build the app and spin up the necessary services:
* ```make build``` to build the docker image for the app
* ```make setup``` to setup and run the containers running kafka
* ```make mktopic``` to create the 'dogs_public' topic
* ```make runapp``` to run the 'dog producer' service
* The service should now be pushing 'dog' events to the "dogs_public" topic on a 2 second timer and output the consumed messages into the console.
* Finally, ```make destroy``` to stop and remove all associated containers

### Extras ###

* To test that avro serialization is working properly, you can use ```make producer``` to initiate a separate dog producer service that takes user input.
* Type a message into the console, notice that an error will be thrown if your message doesn't match the expected 'dog-schema.avsc' schema.
