import pytest
from fastapi.testclient import TestClient
from main import app
from main import about_var

client = TestClient(app)


def test_health_check():
    """Test the health check endpoint"""
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"data": "Healthy"}


def test_about_endpoint():
    """Test the about endpoint that reads API key"""
    response = client.get("/about")
    assert response.status_code == 200
    assert "data" in response.json()
    # The response should contain data from the API key file
    assert f"{about_var} from" in response.json()["data"]


def test_invalid_endpoint():
    """Test that invalid endpoints return 404"""
    response = client.get("/invalid")
    assert response.status_code == 404
