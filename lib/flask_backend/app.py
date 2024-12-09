from flask import Flask, request, jsonify, send_from_directory
from flask_sqlalchemy import SQLAlchemy
import os

# Ruta de la carpeta generada por Flutter
BUILD_FOLDER = os.path.join(os.getcwd(), 'build', 'web')

# Configurar Flask para apuntar a la carpeta de Flutter build
app = Flask(__name__, static_folder=BUILD_FOLDER)

# Configuración de la base de datos SQLite
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///chat.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# Modelo para los mensajes
class ChatMessage(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_message = db.Column(db.String(200), nullable=False)
    bot_response = db.Column(db.String(200), nullable=False)

# Ruta para manejar los mensajes del chat
@app.route('/chat', methods=['POST'])
def chat():
    data = request.json
    user_message = data.get('message', '').lower()

    # Lógica específica para accesorios móviles
    if "hola" in user_message:
        response = ("¡Hola! Bienvenido a nuestra tienda de accesorios móviles. ¿En qué puedo ayudarte hoy?\n"
                    "Puedes preguntar por:\n"
                    "- Forros para móviles\n"
                    "- Vidrios templados\n"
                    "- Auriculares\n"
                    "- Cargadores")
    elif "precio" in user_message:
        response = ("Los precios varían según el producto. Tenemos:\n"
                    "- Forros desde $10\n"
                    "- Vidrios templados desde $5\n"
                    "- Auriculares desde $20\n"
                    "- Cargadores desde $15\n"
                    "¿Sobre qué producto te gustaría más detalles?")
    else:
        response = "Lo siento, no entendí tu mensaje. ¿Puedes elegir una de estas opciones?"

    # Guardar el mensaje y la respuesta en la base de datos
    new_message = ChatMessage(user_message=user_message, bot_response=response)
    db.session.add(new_message)
    db.session.commit()

    return jsonify({"response": response})


@app.route('/favicon.ico')
def favicon():
    # Ruta para intentar servir el favicon si existe
    favicon_path = os.path.join(BUILD_FOLDER, 'favicon.png')
    if os.path.exists(favicon_path):
        return send_from_directory(BUILD_FOLDER, 'favicon.png')
    return '', 204


# Ruta principal para servir index.html generado por Flutter
@app.route('/')
def serve_index():
    try:
        return send_from_directory(BUILD_FOLDER, 'index.html')
    except FileNotFoundError:
        return jsonify({"error": "No se pudo encontrar el archivo index.html"}), 500


# Ruta catch-all para cualquier solicitud (para rutas internas de Flutter)
@app.route('/<path:path>')
def serve_static(path):
    try:
        return send_from_directory(BUILD_FOLDER, path)
    except FileNotFoundError:
        return send_from_directory(BUILD_FOLDER, 'index.html')


# Manejador de error 404 para asegurarse de redirigir a index.html
@app.errorhandler(404)
def handle_404(e):
    return send_from_directory(BUILD_FOLDER, 'index.html')


if __name__ == '__main__':
    # Crear la base de datos y sus tablas si no existen
    with app.app_context():
        db.create_all()

    # Iniciar el servidor Flask
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
