# 🚀 GUÍA DE EJECUCIÓN - BookVerse

## 🎯 Cómo Ejecutar la App

### ✅ Requisitos Previos
- Flutter SDK instalado
- Dart SDK (incluido con Flutter)
- Emulador Android/iOS O dispositivo físico
- VS Code o Android Studio

### 📋 Paso 1: Abrir Terminal

Abre PowerShell o Cmd en la carpeta del proyecto:

```powershell
cd "c:\Users\josue\Documents\fluter multiplataforma\semana16\app_final"
```

---

## 🚀 OPCIÓN 1: Ejecución Rápida

```bash
flutter run
```

Esto abrirá un menú para seleccionar el dispositivo:

```
[1]: Windows (windows)
[2]: Chrome (chrome)  
[3]: Edge (edge)
```

Ingresa el número y presiona Enter.

---

## 🎯 OPCIÓN 2: Seleccionar Dispositivo Específico

### Android (Emulador o Dispositivo)
```bash
flutter run -d android
```

### iOS (Emulador)
```bash
flutter run -d ios
```

### Windows (Desktop)
```bash
flutter run -d windows
```

### Web (Chrome)
```bash
flutter run -d chrome
```

### Web (Firefox)
```bash
flutter run -d firefox
```

---

## 🔧 OPCIÓN 3: Con Parámetros Avanzados

### Modo Debug (por defecto)
```bash
flutter run
```

### Modo Release (más rápido)
```bash
flutter run --release
```

### Modo Profile (análisis de rendimiento)
```bash
flutter run --profile
```

### Verbose (ver todos los logs)
```bash
flutter run -v
```

### Hot Reload automático
Durante la ejecución, presiona `r` para recargar.

---

## 🛠️ PASO A PASO COMPLETO

### 1. Limpiar el proyecto (primera vez)
```bash
flutter clean
```

### 2. Obtener dependencias
```bash
flutter pub get
```

### 3. Ejecutar análisis
```bash
flutter analyze
```

### 4. Ejecutar la app
```bash
flutter run
```

### 5. Seleccionar dispositivo
```
Please choose one (or "q" to quit): 1
```

---

## 📱 Verificar Dispositivos Disponibles

```bash
flutter devices
```

Mostrará algo como:
```
Android Emulator • emulator-5554 • android-x86 • Android 13 (API 33)
Chrome           • chrome          • web-javascript • 
Windows          • windows         • windows-x64
```

---

## ✨ Primeros Pasos en la App

1. **Abre la app** → Verás HomeScreen vacía
2. **Toca el botón azul** "Buscar Libros" en la esquina inferior
3. **Escribe un título** (ej: "Harry Potter")
4. **Espera los resultados** (1-2 segundos)
5. **Toca un libro** para ver detalles
6. **Presiona Guardar** para agregarlo a tu biblioteca
7. **Presiona Favorito** para marcarlo
8. **Vuelve atrás** y verás tu biblioteca actualizada

---

## 🎮 Controles Principales

| Acción | Efecto |
|--------|--------|
| **Tap en tarjeta** | Ver detalles |
| **Tap en corazón** | Cambiar favorito |
| **Swipe atrás** | Volver a pantalla anterior |
| **FAB naranja** | Ir a búsqueda |
| **Bottom tabs** | Cambiar entre Biblioteca y Favoritos |
| **Press 'r'** (en terminal) | Hot reload |
| **Press 'R'** (en terminal) | Hot restart |

---

## 🐛 Solucionar Problemas

### Error: "No devices found"
```bash
flutter doctor -v
# Si falta Android SDK o emulador:
flutter emulators --launch Emulator-Name
```

### Error: "Gradle build failed"
```bash
flutter clean
flutter pub get
flutter run
```

### Error: "Plugin not found"
```bash
flutter pub get
flutter run
```

### App lenta en emulador
```bash
flutter run --release
```

### Ver logs detallados
```bash
flutter run -v
```

---

## 🎨 Durante la Ejecución

### Teclas útiles
- `r` - Hot reload (recarga código)
- `R` - Hot restart (reinicia todo)
- `h` - Mostrar opciones
- `q` - Salir

### Atajos comunes
```
[!] Help       [r] Reload     [R] Restart    [q] Quit
[w] Run widget tests
```

---

## 📊 Verificar que Todo Funciona

- [x] App se abre sin crashes
- [x] Puedes escribir en el campo de búsqueda
- [x] Los resultados aparecen
- [x] Puedes guardar libros
- [x] Puedes marcar favoritos
- [x] Puedes ver detalles
- [x] Puedes eliminar libros
- [x] Bottom navigation funciona
- [x] Sin errores en consola

---

## 🔍 Inspeccionar y Debuguear

### Abrir DevTools
```bash
flutter run
# Luego en consola escribe:
# 'd' para DevTools
```

O directamente:
```bash
flutter pub global run devtools
```

### Ver estados
En DevTools puedes:
- Ver widget tree
- Inspeccionar propiedades
- Ver performance
- Ver logs en tiempo real

---

## 📱 En Dispositivo Físico

### 1. Conectar dispositivo
- Encender depuración en desarrollo
- Conectar con USB
- Autorizar en el dispositivo

### 2. Ejecutar
```bash
flutter run
```

### 3. Aceptar instalación
- La app se instalará automáticamente
- Aparecerá en el menú de apps

---

## 🎯 Compilar para Distribución

### Android (.apk)
```bash
flutter build apk
# El .apk está en: build/app/outputs/flutter-apk/
```

### Android (.aab para Play Store)
```bash
flutter build appbundle
# El .aab está en: build/app/outputs/bundle/
```

### iOS (.ipa)
```bash
flutter build ios --release
```

### Windows (.exe)
```bash
flutter build windows --release
# El exe está en: build/windows/runner/Release/
```

---

## 📈 Monitorear Rendimiento

### Analizar tamaño
```bash
flutter build apk --analyze-size
```

### Ver dependencias
```bash
flutter pub deps
```

### Verificar actualización
```bash
flutter upgrade
```

---

## 💡 Tips de Desarrollo

1. **Usa hot reload** para desarrollo rápido
2. **Revisa DevTools** para debugging
3. **Usa print()** o **debugPrint()** para logs
4. **Ejecuta tests** regularmente
5. **Mantén código limpio** con format

---

## 🔄 Ciclo Típico de Desarrollo

```
1. flutter run
   ↓
2. Realiza cambios en código
   ↓
3. Presiona 'r' en terminal (hot reload)
   ↓
4. Ve cambios inmediatamente
   ↓
5. Repite desde paso 2
```

---

## 📝 Ejemplo Completo

```bash
# 1. Navega al proyecto
cd "c:\Users\josue\Documents\fluter multiplataforma\semana16\app_final"

# 2. Limpia (primera vez)
flutter clean

# 3. Obtén dependencias
flutter pub get

# 4. Verifica que todo está ok
flutter doctor

# 5. Ejecuta
flutter run

# 6. Selecciona dispositivo
# Escribe: 1 (para Windows/Android/etc)

# 7. Espera a que compile y abra

# 8. ¡Disfruta!
```

---

## 🎉 ¡Listo!

Tu app **BookVerse** está completamente funcional y lista para usar.

Si todo funciona correctamente verás:
```
✓ Compiling Dart to native code (Release build on Windows)...
✓ Build complete
✓ The Gradle build finished successfully
✓ App launched successfully!
```

---

## 🆘 Si Necesitas Ayuda

### Comandos útiles
```bash
flutter doctor              # Diagnóstico completo
flutter pub upgrade         # Actualizar dependencias
flutter analyze             # Análisis de código
flutter format             # Formatear código
flutter clean              # Limpiar caché
flutter run --help         # Ver opciones
```

### Revisar documentación
```bash
flutter --version          # Ver versión
flutter devices            # Ver dispositivos
flutter emulators          # Ver emuladores
```

---

## ✅ Checklist Antes de Ejecutar

- [x] Flutter SDK instalado
- [x] Proyecto en carpeta correcta
- [x] Emulador abierto (si lo usas)
- [x] Dependencias descargadas (`flutter pub get`)
- [x] Código compila sin errores (`flutter analyze`)
- [x] Terminal abierta en carpeta del proyecto

---

**¡A disfrutar de BookVerse! 📚✨**

*Ejecuta `flutter run` y que comience la aventura...*
