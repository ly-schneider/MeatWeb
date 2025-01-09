import os
from flask import Flask, jsonify, request
from mangum import Mangum
from asgiref.wsgi import WsgiToAsgi
from discord_interactions import verify_key_decorator

DISCORD_PUBLIC_KEY = os.environ.get("DISCORD_PUBLIC_KEY")

app = Flask(__name__)
asgi_app = WsgiToAsgi(app)
handler = Mangum(asgi_app)

@app.route("/", methods=["POST"])
async def interactions():
    print(f"👉 Request: {request.json}")
    raw_request = request.json
    return interact(raw_request)

@verify_key_decorator(DISCORD_PUBLIC_KEY)
def interact(raw_request):
    if raw_request["type"] == 1:  # PING
        response_data = {"type": 1}  # PONG
    else:
        data = raw_request["data"]
        command_name = data["name"]

        if command_name == "cords":
            subcommand = data["options"][0]["name"]
    
            if subcommand == "add":
                options = data["options"][0]["options"]
                name = next(option["value"] for option in options if option["name"] == "name")
                x = next(option["value"] for option in options if option["name"] == "x")
                y = next(option["value"] for option in options if option["name"] == "y")
                z = next(option["value"] for option in options if option["name"] == "z")
                
                message_content = f"Coordinate '{name}' added with values: X={x}, Y={y}, Z={z}."

                # TODO: Implement saving the coordinates
            
            elif subcommand == "list":
                # TODO: Implement fetching all coordinates
                message_content = "Listing all coordinates... (stubbed)"
            
            elif subcommand == "remove":
                options = data["options"][0]["options"]
                name = next(option["value"] for option in options if option["name"] == "name")
                
                message_content = f"Coordinate '{name}' removed."

                # TODO: Implement removing the coordinate
            else:
                message_content = "Unknown subcommand for 'cords'."
        else:
            message_content = "Unknown command."

        response_data = {
            "type": 4,
            "data": {"content": message_content},
        }

    return jsonify(response_data)

if __name__ == "__main__":
    app.run(debug=True)
