rebuild:
	docker compose down
	docker compose build
	docker compose up

iotop:
	docker exec -it --privileged data-gen-db-1 iotop -oPa

shell:
	docker exec -it data-gen-db-1 bash

tail:
	@latest_file=$$(ls -t ./logs | head -n1); \
	echo "Latest log file: $$latest_file"; \
	tail -f "./logs/$$latest_file"