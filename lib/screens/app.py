from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/chat', methods=['POST'])
def chat():
    data = request.json
    user_message = data.get('message', '')

    # Lógica básica de respuesta
    if "hola" in user_message.lower():
        response = "¡Hola! ¿En qué puedo ayudarte?"
    elif "precio" in user_message.lower():
        response = "Los precios varían según el producto. ¿Qué estás buscando?"
    else:
        response = "Lo siento, no entendí tu mensaje. ¿Podrías ser más específico?"

    return jsonify({"response": response})

if __name__ == '__main__':
    app.run(debug=True)
