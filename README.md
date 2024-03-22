# HomeBase14 - a custom home automation app

[![Flutter](https://github.com/vindolin/HomeBase14/actions/workflows/flutter.yaml/badge.svg)](https://github.com/vindolin/HomeBase14/actions/workflows/flutter.yaml)

> [!WARNING]
> This app is tailored to my specific environment and does not work as a general home automation app !


This project was initiated as a platform for me to acquire knowledge in Flutter/Dart, providing a practical scenario to refine my skills.

Being an enthusiast of open-source home automation and owning a variety of devices with diverse MQTT payloads, this project presented an excellent chance to substitute the multiple control programs with one that is custom-made for my requirements.

I experimented with various reactive state frameworks before settling on Riverpod for data-binding.

I really like Flutter's declarative approach and the robustness of the resulting app.

The project is currently a work in progress, and with the knowledge I’ve gained about Flutter/Dart and the libraries I’m utilizing, there are numerous aspects I would approach differently now.

I am continually refactoring past errors and incorporating new devices as they become part of our household.

This app let's me control/monitor the following devices via MQTT messages:

#### Zigbee
* Window blinds (single and dual)
* Thermostats (underfloor heating)
* Ikea smart bulbs (and other dump bulbs)
* Garden zistern pump
* Sodastream uses (vibration sensor)
* Multi power strip
* Door contact sensors
* Humidity/Temp sensors

#### Wifi
* Garage door (ESP32 controlling a remote controll via transistor)
* various Tasmota plugs
* Plant watering system for a coffee bush (ESP8266, servo valve)
* Incubator for Tempeh etc. (ESP32)

#### Other
* Basic IR remote controll for TV and sound bar
* Metrics of my SMA Tripower solar controller (modbus)
* Prusa I3 MK3s (USB Serial controller)
* Sleep modes and output device of my main PC
* Temperature sensors in my greenhouse (LoRa)

It also let me view the RTSP streams of two survailance cams ([media_kit](https://github.com/media-kit/media-kit))

> [!TIP]
> You can find an example bare bones MQTT/Riverpod example that uses a family provider here: https://github.com/vindolin/simple_mqtt_riverpod_example


### Screenshots
<img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-31-52-061.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-31-58-409.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-11-05-34-632.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-35-07-439.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-15-56-41-262.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-35-13-734.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-15-56-47-305.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-35-29-469.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-35-35-424.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-36-18-264.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-09-22-16-51-712.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-36-29-787.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-36-35-911.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-39-56-128.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-42-16-694.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-46-53-712.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-09-13-53-20-707.jpg" width="200">
