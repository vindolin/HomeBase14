# HomeBase14 - a custom home automation app

[![Flutter](https://github.com/vindolin/HomeBase14/actions/workflows/flutter.yaml/badge.svg)](https://github.com/vindolin/HomeBase14/actions/workflows/flutter.yaml)

**Warning!** This app only works in my specific environment but maybe parts can be useful for beginners looking into writing a Flutter/Riverpod/MQTT app themselves.

You can find a bare bones example here: https://github.com/vindolin/simple_mqtt_riverpod_example

<img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-31-52-061.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-31-58-409.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-11-05-34-632.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-35-07-439.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-15-56-41-262.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-35-13-734.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-15-56-47-305.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-35-29-469.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-35-35-424.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-36-18-264.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-09-22-16-51-712.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-36-29-787.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-36-35-911.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-39-56-128.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-42-16-694.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-08-10-46-53-712.jpg" width="200"> <img src="https://github.com/vindolin/HomeBase14/blob/master/.github/screenshots/screenshot__2023-12-09-13-53-20-707.jpg" width="200">

I started this project because I wanted to learn Flutter/Dart and I needed a real-life project to safely sharpen my claws on.

As a fan of open source home automation and a lot of heterogeneous devices all having different styles of MQTT payloads, this was a good opportunity to replace all the different control programs with one tailored to my needs.

After trying different reactive state frameworks, I chose Riverpod for data-binding and while all the different providers and their notifiers irritated me a lot at the beginning, I'm really happy with that decision now.

I really like Flutter's declarative approach and the robustness of the resulting app.

This project is Work In Progress and there's a lot of stuff that I would do different now after I learned more about Flutter/Dart and the libraries I'm using.

I'm randomly refactoring old mistakes and add new gadgets whenever they appear in our house.

