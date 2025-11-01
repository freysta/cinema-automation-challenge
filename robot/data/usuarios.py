from faker import Faker

def generate_user_data():
    fake = Faker('pt_BR')
    name = fake.name()
    email = fake.email()
    password = fake.password(length=10, special_chars=True, digits=True, upper_case=True, lower_case=True)
    return {
        "name": name,
        "email": email,
        "password": password
    }

def get_registration_payload():
    user_data = generate_user_data()
    return {
        "name": user_data["name"],
        "email": user_data["email"],
        "password": user_data["password"]
    }

# Exemplo de uso (para demonstração)
if __name__ == '__main__':
    print("Generated User Data:")
    print(generate_user_data())
    print("\nRegistration Payload Example:")
    print(get_registration_payload())