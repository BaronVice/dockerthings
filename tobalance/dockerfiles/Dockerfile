FROM python:3.14.3-alpine3.23

# We need curl for the health check
RUN apk --no-cache add curl

WORKDIR /app

# First, copy dependencies only
COPY requirements.txt .

# Install dependencies
RUN pip install -r requirements.txt

# Copying the app source separately significantly improves 
# build time by using the cache if no new dependencies are added
COPY main.py .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]