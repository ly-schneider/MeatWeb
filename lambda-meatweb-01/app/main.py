import os
import psycopg
import pytz
from datetime import datetime
from flask import Flask, jsonify, request
from mangum import Mangum
from asgiref.wsgi import WsgiToAsgi
from discord_interactions import verify_key_decorator

DISCORD_PUBLIC_KEY = os.environ.get("DISCORD_PUBLIC_KEY")

DB_HOST = os.environ.get("DB_HOST")
DB_PORT = os.environ.get("DB_PORT", 5432)
DB_USER = os.environ.get("DB_USER")
DB_PASSWORD = os.environ.get("DB_PASSWORD")
DB_NAME = os.environ.get("DB_NAME")

app = Flask(__name__)
asgi_app = WsgiToAsgi(app)
handler = Mangum(asgi_app)

def get_db_connection():
    return psycopg.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD,
        dbname=DB_NAME
    )

@app.route("/", methods=["POST"])
async def interactions():
    print(f"👉 Anfrage: {request.json}")
    raw_request = request.json
    return interact(raw_request)

@verify_key_decorator(DISCORD_PUBLIC_KEY)
def interact(raw_request):
    """Haupt-Interaktions-Handler."""
    if raw_request["type"] == 1:  # DISCORD PING PONG
        response_data = {"type": 1}
        return jsonify(response_data)

    data = raw_request["data"]
    command_name = data["name"]
    member = raw_request["member"]

    if command_name == "cords":
        subcommand = data["options"][0]["name"]

        if subcommand == "add":
            options = data["options"][0]["options"]
            name = next(option["value"] for option in options if option["name"] == "name")
            x = next(option["value"] for option in options if option["name"] == "x")
            y = next(option["value"] for option in options if option["name"] == "y")
            z = next(option["value"] for option in options if option["name"] == "z")

            try:
                with get_db_connection() as conn:
                    with conn.cursor() as cur:
                        sql = "SELECT ID_Profile FROM Profile WHERE Name = %s;"
                        cur.execute(sql, (member["user"]["username"],))
                        profile_id = cur.fetchone()

                        if not profile_id:
                            sql = "INSERT INTO Profile (Name) VALUES (%s) RETURNING ID_Profile;"
                            cur.execute(sql, (member["user"]["username"],))
                            profile_id = cur.fetchone()[0]
                        else:
                            profile_id = profile_id[0]

                        sql = "SELECT ID_Coordinate FROM Coordinate WHERE Name = %s AND Profile_ID = %s;"
                        cur.execute(sql, (name, profile_id))
                        existing_coordinate = cur.fetchone()

                        if existing_coordinate:
                            message_content = f"Koordinate '{name}' existiert bereits für dein Profil."
                        else:
                            sql = """
                                INSERT INTO Coordinate (Name, X, Y, Z, Profile_ID)
                                VALUES (%s, %s, %s, %s, %s);
                            """
                            cur.execute(sql, (name, x, y, z, profile_id))
                            message_content = f"Koordinate '{name}' mit Werten: X={x}, Y={y}, Z={z} zu deinem Profil hinzugefügt."
                        conn.commit()

            except Exception as e:
                message_content = f"Fehler beim Hinzufügen der Koordinate: {str(e)}"

        elif subcommand == "list":
            try:
                with get_db_connection() as conn:
                    with conn.cursor() as cur:
                        sql = """
                            SELECT C.Name, C.X, C.Y, C.Z, C.CreatedAt
                            FROM Coordinate C
                            JOIN Profile P ON C.Profile_ID = P.ID_Profile
                            WHERE P.Name = %s;
                        """
                        cur.execute(sql, (member["user"]["username"],))
                        coordinates = cur.fetchall()

                        if not coordinates:
                            message_content = "Keine Koordinaten für dein Profil gefunden."
                        else:
                            # UTC+1 Zeitzone
                            utc = pytz.utc
                            cet = pytz.timezone('Europe/Berlin')

                            def format_coordinate(coord):
                                created_at_utc = coord[4].replace(tzinfo=utc)
                                created_at_cet = created_at_utc.astimezone(cet)
                                formatted_time = created_at_cet.strftime("%d.%m.%Y %H:%M:%S")
                                return f"{coord[0]}: X: **{coord[1]}**, Y: **{coord[2]}**, Z: **{coord[3]}**. Erstellt am: {formatted_time}"

                            coordinates_list = "\n".join(
                                format_coordinate(coordinate) for coordinate in coordinates
                            )
                            message_content = f"Koordinaten für dein Profil:\n\n{coordinates_list}"

            except Exception as e:
                message_content = f"Fehler beim Abrufen der Koordinaten: {str(e)}"

        elif subcommand == "remove":
            options = data["options"][0]["options"]
            name = next(option["value"] for option in options if option["name"] == "name")

            try:
                with get_db_connection() as conn:
                    with conn.cursor() as cur:
                        sql = "SELECT ID_Profile FROM Profile WHERE Name = %s;"
                        cur.execute(sql, (member["user"]["username"],))
                        profile_id = cur.fetchone()

                        if not profile_id:
                            message_content = f"Keine Koordinate '{name}' für dein Profil gefunden."
                        else:
                            profile_id = profile_id[0]

                            sql = "SELECT ID_Coordinate FROM Coordinate WHERE Name = %s AND Profile_ID = %s;"
                            cur.execute(sql, (name, profile_id))
                            coordinate_id = cur.fetchone()

                            if not coordinate_id:
                                message_content = f"Keine Koordinate '{name}' für dein Profil gefunden."
                            else:
                                sql = "DELETE FROM Coordinate WHERE ID_Coordinate = %s;"
                                cur.execute(sql, (coordinate_id[0],))
                                conn.commit()
                                message_content = f"Koordinate '{name}' erfolgreich aus deinem Profil entfernt."
            except Exception as e:
                message_content = f"Fehler beim Entfernen der Koordinate: {str(e)}"

        else:
            message_content = "Unbekannter Unterbefehl für 'cords'."
    else:
        message_content = "Unbekannter Befehl."

    response_data = {
        "type": 4,
        "data": {"content": message_content},
    }
    return jsonify(response_data)

if __name__ == "__main__":
    app.run(debug=True)
