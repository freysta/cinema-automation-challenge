# Dados de usuários para testes
USERS = {
    "admin": {
        "email": "admin@test.com",
        "password": "admin123",
        "role": "admin"
    },
    "user": {
        "email": "user@test.com",
        "password": "user123",
        "role": "user"
    }
}

def get_user_data(role):
    return USERS.get(role, {})
