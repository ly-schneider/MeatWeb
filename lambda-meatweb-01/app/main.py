import os
from flask import Flask, jsonify, request
from mangum import Mangum
from asgiref.wsgi import WsgiToAsgi
from discord_interactions import verify_key_decorator
import psycopg
from datetime import datetime
import pytz

# Environment Variables
DISCORD_PUBLIC_KEY = os.getenv("DISCORD_PUBLIC_KEY")
DB_CONFIG = {
    "host": os.getenv("DB_HOST"),
    "port": os.getenv("DB_PORT", 5432),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "dbname": os.getenv("DB_NAME")
}

# Flask Setup
app = Flask(__name__)
asgi_app = WsgiToAsgi(app)
handler = Mangum(asgi_app)

def get_db_connection():
    return psycopg.connect(**DB_CONFIG)

def execute_query(sql, params=(), fetchone=False, fetchall=False):
    """Helper function to interact with the database."""
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(sql, params)
            if fetchone:
                return cur.fetchone()
            if fetchall:
                return cur.fetchall()
            conn.commit()

@app.route("/", methods=["POST"])
async def interactions():
    return interact(request.json)

@verify_key_decorator(DISCORD_PUBLIC_KEY)
def interact(raw_request):
    if raw_request.get("type") == 1:  # Discord PING
        return jsonify({"type": 1})

    command = raw_request["data"]["name"]
    subcommand = raw_request["data"].get("options", [{}])[0].get("name")
    user = raw_request["member"]["user"]["username"]

    if command == "cords":
        return jsonify(handle_cords_command(subcommand, raw_request, user))

    return jsonify({"type": 4, "data": {"content": "Unbekannter Befehl."}})

def handle_cords_command(subcommand, raw_request, username):
    options = raw_request["data"].get("options", [{}])[0].get("options", [])

    if subcommand == "add":
        return handle_add_command(options, username)

    if subcommand == "list":
        return handle_list_command(username)

    if subcommand == "remove":
        return handle_remove_command(options, username)

    return {"type": 4, "data": {"content": "Unbekannter Unterbefehl."}}

def handle_add_command(options, username):
    try:
        name, x, y, z = [get_option_value(options, key) for key in ("name", "x", "y", "z")]
        profile_id = get_or_create_profile(username)

        existing = execute_query(
            "SELECT ID_Coordinate FROM Coordinate WHERE Name = %s AND Profile_ID = %s;",
            (name, profile_id),
            fetchone=True
        )

        if existing:
            return {"type": 4, "data": {"content": f"Koordinate '{name}' existiert bereits."}}

        execute_query(
            """
            INSERT INTO Coordinate (Name, X, Y, Z, Profile_ID)
            VALUES (%s, %s, %s, %s, %s);
            """,
            (name, x, y, z, profile_id)
        )

        return {"type": 4, "data": {"content": f"Koordinate '{name}' hinzugefügt."}}
    except Exception as e:
        return {"type": 4, "data": {"content": f"Fehler: {str(e)}"}}

def handle_list_command(username):
    try:
        sql = """
            SELECT C.Name, C.X, C.Y, C.Z, C.CreatedAt
            FROM Coordinate C
            JOIN Profile P ON C.Profile_ID = P.ID_Profile
            WHERE P.Name = %s;
        """
        coordinates = execute_query(sql, (username,), fetchall=True)

        if not coordinates:
            return {"type": 4, "data": {"content": "Keine Koordinaten gefunden."}}

        formatted_coords = format_coordinates(coordinates)
        return {"type": 4, "data": {"content": formatted_coords}}
    except Exception as e:
        return {"type": 4, "data": {"content": f"Fehler: {str(e)}"}}

def handle_remove_command(options, username):
    try:
        name = get_option_value(options, "name")
        profile_id = get_profile_id(username)

        if not profile_id:
            return {"type": 4, "data": {"content": "Profil nicht gefunden."}}

        existing = execute_query(
            "SELECT ID_Coordinate FROM Coordinate WHERE Name = %s AND Profile_ID = %s;",
            (name, profile_id),
            fetchone=True
        )

        if not existing:
            return {"type": 4, "data": {"content": f"Koordinate '{name}' nicht gefunden."}}

        execute_query("DELETE FROM Coordinate WHERE ID_Coordinate = %s;", (existing[0],))
        return {"type": 4, "data": {"content": f"Koordinate '{name}' entfernt."}}
    except Exception as e:
        return {"type": 4, "data": {"content": f"Fehler: {str(e)}"}}

def get_profile_id(username):
    return execute_query("SELECT ID_Profile FROM Profile WHERE Name = %s;", (username,), fetchone=True)

def get_or_create_profile(username):
    profile = get_profile_id(username)

    if not profile:
        return execute_query(
            "INSERT INTO Profile (Name) VALUES (%s) RETURNING ID_Profile;",
            (username,),
            fetchone=True
        )[0]

    return profile[0]

def get_option_value(options, key):
    return next(option["value"] for option in options if option["name"] == key)

def format_coordinates(coordinates):
    utc = pytz.utc
    cet = pytz.timezone('Europe/Berlin')

    formatted_coords = []
    for name, x, y, z, created_at in coordinates:
        local_time = created_at.replace(tzinfo=utc).astimezone(cet).strftime("%d.%m.%Y %H:%M")
        formatted_coords.append(f"{name}: X=**{x}**, Y=**{y}**, Z=**{z}**, Erstellt am: {local_time}")

    return "\n".join(formatted_coords)

if __name__ == "__main__":
    app.run(debug=True)
