# README #

Golang Kafka event generator POC

### What is this repository for? ###

* We want an example of how to integrate with a Kafka cluster from k8s while we develop on local machines, so we can maintain Go services at scale. <br />
This project is a simple CLI-based app that pushes avro-serialized 'dog' events to a local kafka cluster.
* version 0.0.1

### How do I get set up? ###

* Clone the repo
* In the repo root, there is a Makefile containing docker commands to configure and run the app
* In your CLI, type these commands...
* ```make build``` to build the docker image for the app
* ```make setup``` to setup and run the containers running kafka
* ```make mktopic``` to create the "dogs_public" topic
* ```make runapp``` to run the dog-producer
* The app should now be pushing 'dog' events to the "dogs_public" topic on a 2 second timer and output the consumed events into the console.
* Finally, ```make destroy``` to stop and remove all associated containers

### Extras ###

* To test that avro serialization is working properly, you can use ```make producer``` to initiate a native kafka producer from the console, <br />
which is configured to talk to our local cluster.
* Type any message into the console, notice that an error will be thrown if your message failed validation against the schema defined in 'dog-schema.avsc'