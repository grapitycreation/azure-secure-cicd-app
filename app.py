from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def hello():
    # Lấy một biến môi trường để thử nghiệm, nếu không có thì dùng giá trị mặc định
    greeting = os.environ.get("GREETING", "Hello")
    return f"<h1>{greeting}, This is a test!</h1>"

if __name__ == "__main__":
    app.run(debug=True)