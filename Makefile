APP_IMAGE_NAME = "dogs-image"
APP_CONTAINER_NAME = "dogs"
TOPIC_NAME = "dogs_public"
NETWORK_NAME = "dogs-net"

BROKER = "broker-1"
BROKER_PORT = "9092"

ZOOKEEPER = "zookeeper-1"

SCHEMA_REGISTRY = "schema-registry"
SCHEMA_REGISTRY_PORT = "8081"

APP_LIFETIME = 120

build:
	docker build -t ${APP_IMAGE_NAME}:latest .

setup:
	@docker compose up -d
	@sleep 5

mktopic:
	@docker exec ${BROKER} /bin/kafka-topics --create --if-not-exists --topic ${TOPIC_NAME} --replication-factor 1 --bootstrap-server localhost:${BROKER_PORT} --partitions 1

lstopics:
	@docker exec ${BROKER} /bin/kafka-topics --bootstrap-server=localhost:${BROKER_PORT} --list

rdtopic:
	@docker exec schema-registry /bin/kafka-avro-console-consumer --topic ${TOPIC_NAME} --bootstrap-server ${BROKER}:${BROKER_PORT} --from-beginning

runapp:
# run app container
	docker run -d --name ${APP_CONTAINER_NAME} --network ${NETWORK_NAME} -e KAFKA_URL=${BROKER}:${BROKER_PORT} -e SCHEMA_REGISTRY_URL=http://${SCHEMA_REGISTRY}:${SCHEMA_REGISTRY_PORT} -e KAFKA_TOPIC=${TOPIC_NAME} -e APP_LIFETIME=${APP_LIFETIME} ${APP_IMAGE_NAME}

	@echo
	@echo SPAWNING DOGS...
	@echo

	@make rdtopic

destroy:
	docker stop ${BROKER} ${ZOOKEEPER} ${SCHEMA_REGISTRY}
	docker rm ${BROKER} ${ZOOKEEPER} ${SCHEMA_REGISTRY}
	docker stop ${APP_CONTAINER_NAME}
	docker rm ${APP_CONTAINER_NAME}

# innitiate kafka basic console producer with schema registry, for testing purposes 
producer:
	@docker exec -it schema-registry /bin/kafka-avro-console-producer --broker-list ${BROKER}:${BROKER_PORT} --topic ${TOPIC_NAME} --property schema.registry.url=http://localhost:${SCHEMA_REGISTRY_PORT} --property value.schema.file=/etc/stuff/dog-schema