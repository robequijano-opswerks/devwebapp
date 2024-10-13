from flask import Flask
import webcolors
import os

app = Flask(__name__)

@app.route('/')

def hexto_color_name(hex_color):
    """Convert a hex color code to a color name or closest match."""
    try:
        # Try to get the exact color name
        color_name = webcolors.hex_to_name(hex_color)
    except ValueError:
        # Get the closest matching color name
        rgb_value = webcolors.hex_to_rgb(hex_color)
        closest_color = min(webcolors.CSS3_NAMES_TO_HEX, key=lambda color: sum((webcolors.hex_to_rgb(webcolors.CSS3_NAMES_TO_HEX[color])[i] - rgb_value[i]) ** 2 for i in range(3)))
        color_name = closest_color
    return color_name

def home():
    title = "Welcome to the Main Server"

    # Get the hex color from the environment variable
    hex_color = os.environ.get("COLOR", "#7F00FF")  # Default to white if not set
    color_name = os.environ.get("COLOR_NAME", hex_to_color_name(hex_color))  # Convert hex color to color name
    
    return f'''
        <html>
            <head>
                <title>{title}</title>
                <style>
                    body {{
                        background-color: {os.environ["COLOR"]};
                        font-family: Arial, sans-serif;
                        text-align: center;
                        padding: 50px;
                    }}
                    h1 {{
                        color: #2b2b2b;
                        font-size: 3em;
                        margin-bottom: 10px;
                    }}
                    h2 {{
                        color: #006400;
                        font-size: 2.5em;
                        margin-top: 0;
                    }}
                    p {{
                        color: #333;
                        font-size: 1.2em;
                    }}
                    .container {{
                        max-width: 800px;
                        margin: 0 auto;
                        background-color: #fff;
                        padding: 20px;
                        border-radius: 10px;
                        box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
                    }}
                </style>
            </head>
            <body>
                <div class="container">
                    <h1>TEAM R.H.A.L</h1>
                    <h2>{title}</h2>
                    <p>Welcome to the official main server of Team R.H.A.L.</p>

                    <img src="https://i.ibb.co/xjNxH3J/Screenshot-2024-10-12-at-9-55-42-PM.png" alt="Team R.H.A.L Logo">

                </div>
            </body>
        </html>
    '''

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
