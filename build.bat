flutter build appbundle --target-platform android-arm64
del ..\my_app.apks
java -jar ../bundletool-all-1.14.0.jar build-apks --connected-device --device-id=192.168.178.167:38641 --bundle=C:\Flutter\homer\build\app\outputs\bundle\release\app-release.aab --output=..\my_app.apks
java -jar ../bundletool-all-1.14.0.jar install-apks --device-id=192.168.178.167:38641 --apks=..\my_app.apks
java -jar ../bundletool-all-1.14.0.jar build-apks --connected-device --device-id=UBV0219123000535 --bundle=C:\Flutter\homer\build\app\outputs\bundle\release\app-release.aab --output=..\my_app.apks
java -jar ../bundletool-all-1.14.0.jar install-apks --device-id=UBV0219123000535 --apks=..\my_app.apks
