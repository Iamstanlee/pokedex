# Pokedex

[![build status](https://img.shields.io/github/workflow/status/Iamstanlee/pokedex/CI)](https://github.com/Iamstanlee/pokedex/actions?query=CI)
[![coverage Status](https://coveralls.io/repos/github/Iamstanlee/pokedex/badge.svg?branch=main)](https://coveralls.io/github/Iamstanlee/pokedex?branch=main)

### Preview And Screenshots

<img src="/ss/preview.gif" width="300px" hspace="10"/>

<p>
    <img src="/ss/1.png" width="200px" hspace="10"/>
    <img src="/ss/2.png" width="200px" hspace="10"/>
</p>

<p>
    <img src="/ss/3.png" width="200px" hspace="10"/>
    <img src="/ss/4.png" width="200px" hspace="10"/>
</p>

# Pokedex

## Getting Started 🚀

This project uses a simple layered architecture with seperation of concern, maintainance and
testing in mind.

## Dependencies

This projects depends on a couple of awesome packages

- [equatable](https://pub.dev/packages/equatable/): for simplifying object comparison
- [flutter_bloc](https://bloclibrary.dev/): state management
- [hive](https://hivedb.dev): A lightweight and super fast key-value pair database
- [cached_network_image](https://pub.dev/packages/cached_network_image/): for caching network images
- [dio](https://pub.dev/packages/dio/): http client library

## Running The App

Flutter is required to run this application, see installation docs [here](https://flutter.dev)
When you have flutter installed on your system, Use the following command to run the app on your local emulator/simulator or connected device, this would build and install the app on your device

```sh
$ flutter run
```

## Running Tests 🧪

To run tests, run the following command

```sh
$ flutter test --coverage
```
