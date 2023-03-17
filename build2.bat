adb connect %1
java -jar ../bundletool-all-1.14.0.jar build-apks --connected-device --device-id=%1 --bundle=C:\Flutter\homer\build\app\outputs\bundle\release\app-release.aab --output=..\my_app.apks
java -jar ../bundletool-all-1.14.0.jar install-apks --device-id=%1 --apks=..\my_app.apks
