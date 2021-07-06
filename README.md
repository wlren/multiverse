# multiverse

![multiverse banner](banner.png)

[![build](https://github.com/wlren/multiverse/actions/workflows/build.yml/badge.svg)](https://github.com/wlren/multiverse/actions/workflows/build.yml)
[![web](https://github.com/wlren/multiverse/actions/workflows/web.yml/badge.svg)](https://github.com/wlren/multiverse/actions/workflows/web.yml)
[![lint](https://github.com/wlren/multiverse/actions/workflows/lint.yml/badge.svg)](https://github.com/wlren/multiverse/actions/workflows/lint.yml)
[![Coverage Status](https://coveralls.io/repos/github/wlren/multiverse/badge.svg?branch=main)](https://coveralls.io/github/wlren/multiverse?branch=main)

A mobile application powered by Flutter and AWS Amplify which provides a
one-stop solution to all campus needs.

[View on Github Pages](https://wlren.github.io/multiverse/)

## Motivation
In NUS, there are mainly 3/4 apps that student and staff use:
- uNivUS
- NUS NextBus
- NUS Dining
- NUS Card (deprecated; now integrated with uNivUS)

We have identified the following features that a user should have as top  
priority:
- Temperature/health declaration
- Temperature declaration reminders
- View past temperature declarations
- Bus timings
- Green pass
- Scanning and using meal credits

The following features are also important, but are not top priority:
- School map
- NUS Card QR Code
- Crowd Insight
- View exam results

Students have to switch between these apps on a daily basis and it makes
no sense to have them separated where students have to keep logging in
to separate apps to go about their daily lives in Uni. Why is there not
a good central app where it encapsulates all the features a student
needs to go about their daily lives?

# Build

## Android

```sh
flutter build apk
```

## Web

The current web/index.html has the `<base>` tag's href set to `/multiverse`. Change the href to reflect the base path of whichever domain you're serving from.

> The path provided below has to start and end with a slash `/` in order for it to work correctly.

```sh
flutter build web
cd build/web
python -m http.server # python 3
```
