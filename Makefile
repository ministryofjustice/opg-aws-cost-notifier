default: test build scan lint terraform clean

build:
	docker compose build aws-cost-notifier

test-results:
	mkdir -p -m 0777 test-results .trivy-cache

setup-directories: test-results

scan: setup-directories
	docker compose run --rm trivy image --format table --exit-code 0 311462405659.dkr.ecr.eu-west-1.amazonaws.com/shared/aws-cost-notifier:latest
	docker compose run --rm trivy image --format sarif --output /test-results/trivy.sarif --exit-code 1 311462405659.dkr.ecr.eu-west-1.amazonaws.com/shared/aws-cost-notifier:latest

venv: venv/touchfile

venv/touchfile: lambda/requirements.dev.txt
	test -d venv || python -m venv venv
	. venv/bin/activate; pip install -Ur lambda/requirements.dev.txt
	touch venv/touchfile

test: venv
	. venv/bin/activate; pytest lambda

lint:
	cd local && terraform fmt -check -recursive

terraform:
	cd local && docker compose up -d
	cd local && terraform init
	cd local && terraform validate
	cd local && terraform plan

clean:
	rm -rf venv
	find . -iname '*.pyc' -delete
	cd local && docker compose down
