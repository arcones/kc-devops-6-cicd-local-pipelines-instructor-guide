# [EXPLANATION] What a pipeline is
# [EXPLANATION] makefile explanation. What they are invented for, what they are used for
# [EXPLANATION] Explain semantics: Target, etc

all: clean build unit-test coverage version package publish dockerize push integration-test

# [EXPLANATION]: Idempotency and immutability (bullet proof)
# [EXPLANATION]: Chain targets
# [MANAGEMENT]: This clean step will be added at the end
clean:
	@echo CLEAN STEP
	find python-example-app -type d -name '*cache*' -exec rm -rf {} +
	find python-example-app -type f -name '*pyc' -delete
	cd python-example-app && rm -rf src/tests/.coverage src/example-app.egg-info dist
	python3 -m pip uninstall -r python-example-app/requirements.txt -y
	docker rmi martaarcones/example-app-image --force

build:
	@echo BUILD STEP
	cd python-example-app && pip install -r requirements.txt

# [EXPLANATION] Benefits and drawbacks of using same target for several things
unit-test:
	@echo TEST STEP
	cd python-example-app/src/tests && \
		coverage run -m pytest -s -v

# [EXPLANATION] Comment exit error codes. Difference between test has failed from pipeline has failed
coverage:
	@echo COVERAGE STEP
	cd python-example-app/src/tests && coverage report -m --fail-under=90

# [EXPLANATION] Semantic versioning.
version:
	@echo VERSION STEP
	cd python-example-app && bump

# [EXPLANATION] Difference between "build" and "python3 -m build"
package:
	@echo PACKAGE STEP
	cd python-example-app && python3 -m build

# [MANAGEMENT] First do with user and password and later with pypirc
# [EXPLANATION] Talk about efficiency improvements in pipelines (balance)
publish:
	@echo PUBLISH STEP
	cd python-example-app && python3 -m twine upload dist/* --skip-existing --config-file ~/.pypirc

dockerize:
	@echo DOCKERIZE STEP
	cd docker && docker build -f Dockerfile -t martaarcones/example-app-image:latest .

push:
	@echo PUSH STEP
	docker push martaarcones/example-app-image:latest

# [EXPLANATION] Testing at different levels
integration-test:
	@echo INTEGRATION-TEST STEP
	docker run martaarcones/example-app-image:latest