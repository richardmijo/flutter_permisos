# UIDE Permisos - Showcase Educativo

![UIDE Banner](assets/images/uide_logo.png)

**UIDE Permisos** es una aplicación móvil desarrollada en Flutter con fines educativos para la **Universidad Internacional del Ecuador (UIDE)**. Su objetivo principal es demostrar de manera interactiva y técnica cómo gestionar, solicitar y verificar permisos en sistemas operativos Android e iOS.

La aplicación sigue una línea gráfica institucional, utilizando los colores oficiales de la universidad y ofreciendo una experiencia de usuario (UX) premium y moderna.

---

## 📱 Características Principales

La aplicación implementa un sistema robusto de manejo de permisos (`PermissionController`) y cuenta con cinco módulos de demostración interactiva:

### 1. 📸 Cámara (Camera Showcase)
- **Permiso**: `android.permission.CAMERA`
- **Funcionalidad**: Vista previa en tiempo real de la cámara del dispositivo.
- **UI**: Interfaz tipo "HUD" tecnológico con indicadores de "EN VIVO" y esquinas de enfoque animadas.
- **Interacción**: Captura de fotos con feedback visual.

### 2. 📍 Ubicación (Location Showcase)
- **Permiso**: `android.permission.ACCESS_FINE_LOCATION`
- **Funcionalidad**: Rastreo GPS en tiempo real.
- **UI**: Animación de radar pulsante que reacciona al estado del rastreo.
- **Datos**: Visualización precisa de Latitud, Longitud y Velocidad de desplazamiento.

### 3. 🎙️ Micrófono y Audio (Audio Showcase)
- **Permiso**: `android.permission.RECORD_AUDIO`
- **Funcionalidad**: Grabadora de voz funcional.
- **UI**: Visualizador de espectro de audio animado que reacciona a la grabación y reproducción.
- **Extras**: Reproducción inmediata del archivo de audio temporal generado.

### 4. 🖼️ Galería de Fotos
- **Permiso**: `android.permission.READ_EXTERNAL_STORAGE` / `Photos`
- **Funcionalidad**: Selección de imágenes desde la galería nativa.
- **UI**: Contenedor estilizado que muestra la imagen seleccionada o un estado vacío amigable.

### 5. 👥 Contactos
- **Permiso**: `android.permission.READ_CONTACTS`
- **Funcionalidad**: Listado completo de los contactos del dispositivo.
- **UI**: Lista optimizada con avatares generados automáticamente basados en las iniciales del contacto.

---

## 🛠️ Stack Tecnológico

El proyecto está construido sobre **Flutter** y utiliza un conjunto de librerías seleccionadas para garantizar estabilidad y rendimiento:

*   **Core**: `flutter_sdk: >=3.10.4`
*   **Gestión de Permisos**: `permission_handler: ^11.3.0`
*   **Hardware & Sensores**:
    *   `camera`: ^0.10.5
    *   `geolocator`: ^11.0.0
    *   `record`: ^6.0.0 (Grabación de audio cross-platform)
    *   `audioplayers`: ^6.0.0
    *   `image_picker`: ^1.0.7
    *   `flutter_contacts`: ^1.1.9
*   **Diseño & UI**:
    *   `google_fonts`: Tipografía **Poppins**.
    *   `flutter_animate`: Animaciones declarativas de alto rendimiento.
    *   `font_awesome_flutter`: Iconografía profesional.

---

## 🎨 Diseño y Tema

La aplicación implementa un tema personalizado `AppTheme` que refleja la identidad de la UIDE:

*   **Colores Primarios**:
    *   🔴 **Burgundy (Vino)**: `#98004B`
    *   🟡 **Gold (Dorado)**: `#FDB913`
*   **Estilo**: "Light Theme" limpio, con tarjetas blancas (`Surface`), sombras suaves y tipografía legible.
*   **Iconos**: Se han generado iconos adaptativos para Android e iOS con el fondo institucional.

---

## 🚀 Instalación y Ejecución

### Requisitos Previos
*   Flutter SDK instalado.
*   Dispositivo Android (físico o emulador) o dispositivo iOS (macOS requerido).

### Pasos
1.  **Clonar el repositorio**:
    ```bash
    git clone https://github.com/richardmijo/flutter_permisos.git
    cd flutter_permisos
    ```

2.  **Instalar dependencias**:
    ```bash
    flutter pub get
    ```

3.  **Configuración de iOS (Solo macOS)**:
    ```bash
    cd ios
    pod install
    cd ..
    ```

4.  **Ejecutar la aplicación**:
    ```bash
    flutter run
    ```

---

## 📄 Estructura del Proyecto

```
lib/
├── controllers/      # Lógica de negocio (PermissionController)
├── screens/          # Pantallas principales (HomeScreen)
├── showcases/        # Demos interactivos (Camera, Audio, Location, etc.)
├── theme/            # Configuración de tema y colores (AppTheme)
└── widgets/          # Componentes reusables (PermissionCard)
```

---

**Desarrollado para la Clase de Programación Móvil - UIDE**
*Powered by Arizona State University Alliance*
