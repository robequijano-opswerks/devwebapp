FROM python:3.13-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
ARG APP_COLOR=#2c6fc3
ENV APP_COLOR=$APP_COLOR
CMD ["python", "app/main_server.py"]

EXPOSE 5000
