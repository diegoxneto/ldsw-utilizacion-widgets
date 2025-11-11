

import requests
from bs4 import BeautifulSoup
import getpass

# URLs
LOGIN_URL = 'https://desarrolloweb.udgvirtual.udg.mx/login/index.php'
EVENTS_URL = 'https://desarrolloweb.udgvirtual.udg.mx/my/'

def main():
    """
    Inicia sesión y extrae los próximos eventos de la plataforma Moodle.
    """
    try:
        # Usar getpass para una entrada de credenciales segura
        username = input("Ingresa tu usuario: ")
        password = getpass.getpass("Ingresa tu contraseña: ")

        # Crear una sesión para persistir las cookies de inicio de sesión
        with requests.Session() as session:
            print("Obteniendo token de inicio de sesión...")
            
            # 1. Obtener la página de inicio de sesión para extraer el logintoken
            response = session.get(LOGIN_URL)
            response.raise_for_status()  # Asegurarse de que la petición fue exitosa
            
            soup = BeautifulSoup(response.text, 'html.parser')
            logintoken_element = soup.find('input', {'name': 'logintoken'})
            
            if not logintoken_element:
                print("Error: No se pudo encontrar el token de inicio de sesión. El sitio puede haber cambiado.")
                return

            logintoken = logintoken_element['value']
            print("Token obtenido. Intentando iniciar sesión...")

            # 2. Enviar la petición POST para iniciar sesión
            login_payload = {
                'username': username,
                'password': password,
                'logintoken': logintoken,
            }
            
            login_response = session.post(LOGIN_URL, data=login_payload)
            login_response.raise_for_status()

            # Verificar si el inicio de sesión fue exitoso buscando el nombre del usuario en el dashboard
            soup_dashboard = BeautifulSoup(login_response.text, 'html.parser')
            user_profile = soup_dashboard.find('a', {'data-title': 'profile'})
            
            if "login" in login_response.url or not user_profile:
                print("Error: Inicio de sesión fallido. Verifica tus credenciales.")
                return
            
            print(f"Inicio de sesión exitoso como {user_profile.text.strip()}!")
            print("\n--- Navegando a la página de eventos ---\n")

            # 3. Navegar a la página principal/dashboard para encontrar eventos
            events_page_response = session.get(EVENTS_URL)
            events_page_response.raise_for_status()
            
            soup_events = BeautifulSoup(events_page_response.text, 'html.parser')
            
            # Buscar el bloque de "eventos próximos" (común en Moodle)
            upcoming_events_block = soup_events.find('div', id='block-upcoming_events')
            
            if not upcoming_events_block:
                print("No se encontró el bloque de 'eventos próximos'.")
                print("Buscando eventos en el calendario...")
                # Como alternativa, buscar en la vista general del calendario
                upcoming_events_block = soup_events.find('div', id='month-upcoming')


            if upcoming_events_block:
                events = upcoming_events_block.find_all('div', {'class': 'event'})
                if events:
                    print("--- Eventos Próximos Encontrados ---")
                    for event in events:
                        event_name = event.find('div', class_='name').get_text(strip=True)
                        event_date = event.find('div', class_='date').get_text(strip=True)
                        print(f"- {event_name} ({event_date})")
                    print("\n------------------------------------")
                else:
                    print("No hay eventos próximos en el bloque encontrado.")
            else:
                print("No se pudo encontrar ningún bloque de eventos o calendario en la página.")
                print("Nota: La estructura del sitio puede haber cambiado. El script podría necesitar ajustes.")

    except requests.exceptions.RequestException as e:
        print(f"Error de red: {e}")
    except Exception as e:
        print(f"Ocurrió un error inesperado: {e}")

if __name__ == '__main__':
    main()

