# [THEORY] What a pipeline is
# [THEORY] makefile explanation. What they are invented for, what they are used for
# [THEORY] Explain semantics: Target, etc

all: clean build unit-test coverage version package publish dockerize push integration-test

# [THEORY]: Idempotency and immutability (bullet proof)
# [THEORY]: Chain targets
# [MANAGEMENT]: This clean step will be added at the end
clean:
	@echo CLEAN STEP
	find python-example-app -type d -name '*cache*' -exec rm -rf {} +
	find python-example-app -type f -name '*pyc' -delete
	cd python-example-app && rm -rf src/tests/.coverage src/example-app.egg-info dist
	docker rmi martaarcones/example-app-image --force

build:
	@echo BUILD STEP
	cd python-example-app && pip install -r requirements.txt

# [THEORY] Benefits and drawbacks of using same target for several things
unit-test:
	@echo TEST STEP
	cd python-example-app/src/tests && \
		coverage run -m pytest -s -v

# [THEORY] Comment exit error codes. Difference between test has failed from pipeline has failed
# [THEORY] Coverage. Benefits and drawbacks
coverage:
	@echo COVERAGE STEP
	cd python-example-app/src/tests && coverage report -m --fail-under=90

# [THEORY] Semantic versioning.
version:
	@echo VERSION STEP
	cd python-example-app && bump

# [THEORY] Difference between "build" and "python3 -m build"
package:
	@echo PACKAGE STEP
	cd python-example-app && python3 -m build

# [MANAGEMENT] First do with user and password and later with pypirc
# [THEORY] Talk about efficiency improvements in pipelines like skip existing, etc (balance)
publish:
	@echo PUBLISH STEP
	cd python-example-app && python3 -m twine upload dist/* --skip-existing --config-file ~/.pypirc

dockerize:
	@echo DOCKERIZE STEP
	cd docker && docker build -f Dockerfile -t martaarcones/example-app-image:latest .

push:
	@echo PUSH STEP
	docker push martaarcones/example-app-image:latest

# [THEORY] Testing at different levels
integration-test:
	@echo INTEGRATION-TEST STEP
	docker run martaarcones/example-app-image:latest