all: rebuild

rebuild:
	@echo "Waiting for container to start..."
	docker compose down
	docker compose build
	docker compose up -d &
	@until docker ps | grep -q spatial-lsm-tree-benchmark-db; do \
		sleep 1; \
	done

iotop:
	docker exec -it --privileged spatial-lsm-tree-benchmark-db iotop -oPa

shell:
	docker exec -it --privileged spatial-lsm-tree-benchmark-db bash

tail:
	@latest_file=$$(ls -t ./logs/benchmark | head -n1); \
	echo "Latest log file: $$latest_file"; \
	tail -f "./logs/benchmark/$$latest_file"

monitor:
	- tmux kill-session -t monitor-session || true
	tmux new-session -d -s monitor-session 'make iotop' \; \
		split-window -v -p 30 'make tail' \; \
		attach-session -t monitor-session
