default: test build scan lint terraform clean

build:
	docker build --file lambda/Dockerfile --tag aws_cost_notifier:latest lambda

scan:
	trivy image aws_cost_notifier:latest

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
