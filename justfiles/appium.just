# Chequea que existen los paquetes para trabjar con appium
[linux]
appium-packages:
    @echo "||============ Version de la java ============||"
    @java --version
    @echo "||============================================||"
    @echo "\n"

    @echo "||=============== Version de abd =============||"
    @adb --version
    @echo "||============================================||"
    @echo "\n"

    @echo "||=========== Version de sdkmanager ==========||"
    @sdkmanager --version
    @echo "||============================================||"
    @echo "\n"

# Inicializa el proyecto para trabajar con inspector
[linux]
ai:
    @appium --use-plugins=inspector --allow-cors

# Comandos para extrar la ventana actual donde se iniciara los test
[windows]
current-app:
    @adb shell dumpsys window | findstr mCurrentFocus

# Comandos para extrar la ventana actual donde se iniciara los test
[linux]
current-app:
    @adb shell dumpsys window | grep -E 'mCurrentFocus'

# Instala un programa en el celular en la localizacion determinada
[linux]
install-apk device program-adress:
    @adb -s {{device}} install {{program-adress}}
