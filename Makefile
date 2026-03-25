default: test build lint terraform clean

build:
	docker compose build aws-cost-notifier

test-results:
	mkdir -p -m 0777 test-results

setup-directories: test-results

venv: venv/touchfile

venv/touchfile: lambda/requirements.dev.txt
	test -d venv || python -m venv venv
	. venv/bin/activate; pip install -Ur lambda/requirements.dev.txt
	touch venv/touchfile

test: venv
	. venv/bin/activate; pytest lambda

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
