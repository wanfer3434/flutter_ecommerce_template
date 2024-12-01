from flask import Flask, request, jsonify, send_from_directory
from flask_sqlalchemy import SQLAlchemy
import os

# Configura Flask para servir archivos estáticos desde 'build/web'
app = Flask(__name__, static_folder='build/web')

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

# Ruta para servir el archivo 'index.html'
@app.route('/')
def serve_index():
    return send_from_directory(app.static_folder, 'index.html')

# Ruta catch-all para manejar cualquier otra solicitud desconocida
@app.errorhandler(404)
def serve_not_found(e):
    return send_from_directory(app.static_folder, 'index.html')

if __name__ == '__main__':
    # Crea las tablas en la base de datos
    with app.app_context():
        db.create_all()

    port = int(os.environ.get('PORT', 5000))  # Render asignará un puerto automáticamente
    app.run(host='0.0.0.0', port=port)
