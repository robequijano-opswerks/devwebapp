import pytest,re
from app.main_server import app as main_app

@pytest.fixture
def client():
    """Set up the Flask test client for the main server."""
    main_app.config['TESTING'] = True
    with main_app.test_client() as client:
        yield client

def test_background_color(client):
    """Test that the background color is a valid hex color code on the main server."""
    response = client.get('/')
    assert response.status_code == 200

    # Extract the background color from the response data (HTML content)
    html_data = response.data.decode('utf-8')
    background_color = re.search(r'background-color:\s*(#[0-9A-Fa-f]{6})', html_data)

    # Assert that a valid background color was found
    assert background_color is not None, "No valid background color found in the HTML."

    # Further validate that the background color is a valid 6-character hex color
    color = background_color.group(1)
    assert re.match(r'^#[0-9A-Fa-f]{6}$', color), f"Invalid hex color: {color}"
