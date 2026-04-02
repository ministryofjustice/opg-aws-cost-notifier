default: test build lint terraform clean

build:
	docker compose build aws-cost-notifier

test: 
	docker compose run --rm pytest

lint:
	tflint --recursive

terraform:
	cd local && docker compose up -d
	cd local && terraform init
	cd local && terraform validate
	cd local && terraform plan

clean:
	rm -rf venv
	find . -iname '*.pyc' -delete
	cd local && docker compose down
