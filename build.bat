flutter build appbundle --target-platform android-arm64
del ..\my_app.apks
java -jar ../bundletool-all-1.14.0.jar build-apks --connected-device --bundle=C:\Flutter\homer\build\app\outputs\bundle\release\app-release.aab --output=..\my_app.apks
java -jar ../bundletool-all-1.14.0.jar install-apks --apks=..\my_app.apks