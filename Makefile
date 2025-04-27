all: rebuild
	@echo "Waiting for container to start..."
	@until docker ps | grep -q spatial-lsm-tree-benchmark-db; do \
		sleep 1; \
	done
	docker exec -it --privileged spatial-lsm-tree-benchmark-db iotop -oPa

rebuild:
	@echo "Starting rebuild in the background..."
	docker compose down
	docker compose build
	docker compose up -d &

iotop:
	docker exec -it --privileged data-gen-db-1 iotop -oPa

shell:
	docker exec -it data-gen-db-1 bash

tail:
	@latest_file=$$(ls -t ./logs | head -n1); \
	echo "Latest log file: $$latest_file"; \
	tail -f "./logs/$$latest_file"
