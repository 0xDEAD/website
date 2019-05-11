+++
title = "FLIR Lepton"
description = "InfraRed Thermal Camera"
picture = "/img/lepton.jpg"
+++

# Overview

[lepton](https://periph.io/x/periph/devices/lepton) provides support for the
FLIR Lepton InfraRed camera.


# Driver

The driver as the following functionality:

- Full 14 bits depth
- Access to the [CCI interface](https://periph.io/x/periph/devices/lepton/cci)


# Tool

Use
[cmd/lepton](https://github.com/google/periph/blob/master/cmd/lepton/main.go) to
query the camera state, trigger a calibration (FFC) or capture an image.


# Example

Please [edit this page on
GitHub](https://github.com/periph/website/edit/master/site/content/device/lepton.md)
to complete the example. Thanks!

```go
package main

func main() {
    // TODO 😳
}
```


# Buying

The recommended buy is the Lepton breakout board + Lepton with radiometry at at
[GroupGets](https://store.groupgets.com/). This is quite expensive. Note that
this driver was tested with an older version of this board without radiometry.

- GroupGets:
  [store.groupgets.com/collections/flir-lepton-accessories](https://store.groupgets.com/collections/flir-lepton-accessories)

_The periph authors do not endorse any specific seller. These are only provided
for your convenience._
