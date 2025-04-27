rebuild:
	docker compose down
	docker compose build
	docker compose up

iotop:
	docker exec -it --privileged data-gen-db-1 iotop -oPa