from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def home():
    title = "Welcome to the Main Server"
    
    return f'''
        <html>
            <head>
                <title>{title}</title>
                <style>
                    body {{
                        background-color: #{os.environ["APP_COLOR"]};
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

                    <img src="https://i.ibb.co/4Ty2rhs/asd.png" alt="Team R.H.A.L Logo">

                </div>
            </body>
        </html>
    '''

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
