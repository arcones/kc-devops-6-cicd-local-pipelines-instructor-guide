FROM python:3.9.14-slim

RUN pip install example-app-kc

COPY test.py .

ENTRYPOINT ["python", "test.py"]