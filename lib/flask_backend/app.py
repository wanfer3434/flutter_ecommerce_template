from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__)

# Configuración de la base de datos SQLite
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///chat.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# Modelo para los mensajes
class ChatMessage(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_message = db.Column(db.String(200), nullable=False)
    bot_response = db.Column(db.String(200), nullable=False)

# Ruta para manejar los mensajes
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
    elif "forros" in user_message:
        response = ("Tenemos varias opciones de forros para móviles. Elige uno de estos tipos:\n"
                    "- Forros básicos\n"
                    "- Forros antigolpes\n"
                    "- Forros personalizados\n"
                    "¿Para qué modelo de teléfono estás buscando el forro?")
    elif "vidrios" in user_message or "protector de pantalla" in user_message:
        response = ("Tenemos vidrios templados de alta calidad. Elige entre estos tipos:\n"
                    "- Vidrios templados estándar\n"
                    "- Vidrios anti-rayaduras\n"
                    "- Vidrios con borde 3D\n"
                    "¿Para qué modelo de teléfono necesitas el protector de pantalla?")
    elif "auriculares" in user_message:
        response = ("Contamos con diferentes tipos de auriculares. Elige uno:\n"
                    "- Auriculares inalámbricos\n"
                    "- Auriculares con cable\n"
                    "- Auriculares Bluetooth\n"
                    "¿Qué tipo prefieres?")
    elif "cargadores" in user_message:
        response = ("Tenemos varias opciones de cargadores. Elige uno:\n"
                    "- Cargadores rápidos\n"
                    "- Cargadores inalámbricos\n"
                    "- Cargadores universales\n"
                    "¿Qué tipo de cargador te interesa más?")
    elif "gracias" in user_message:
        response = "¡Gracias a ti! Si necesitas más ayuda, estaré encantado de asistirte."
    else:
        response = ("Lo siento, no entendí tu mensaje. ¿Puedes elegir una de estas opciones?\n"
                    "- Forros para móviles\n"
                    "- Vidrios templados\n"
                    "- Auriculares\n"
                    "- Cargadores")

    # Guardar el mensaje y la respuesta en la base de datos
    new_message = ChatMessage(user_message=user_message, bot_response=response)
    db.session.add(new_message)
    db.session.commit()

    return jsonify({"response": response})

if __name__ == '__main__':
    db.create_all()  # Crea las tablas en la base de datos
    port = int(os.environ.get('PORT', 5000))  # Railway asignará un puerto automáticamente
    app.run(host='0.0.0.0', port=port)
