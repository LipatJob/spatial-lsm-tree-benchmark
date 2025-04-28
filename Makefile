all: rebuild
	@echo "Waiting for container to start..."
	@until docker ps | grep -q spatial-lsm-tree-benchmark-db; do \
		sleep 1; \
	done
	docker exec -it --privileged spatial-lsm-tree-benchmark-db iotop -oPa

rebuild:
	docker compose down
	docker compose build
	docker compose up

iotop:
	docker exec -it --privileged spatial-lsm-tree-benchmark-db iotop -oPa

shell:
	docker exec -it --privileged spatial-lsm-tree-benchmark-db bash

tail:
	@latest_file=$$(ls -t ./logs/benchmark | head -n1); \
	echo "Latest log file: $$latest_file"; \
	tail -f "./logs/$$latest_file"

tail-network:
	@latest_file=$$(ls -t ./logs/network | head -n1); \
	echo "Latest log file: $$latest_file"; \
	tail -f "./logs/network/$$latest_file"
