+++
title = "Design"
description = "Dive into key design elements"
+++


Read more [about the goals](../goals/) first if necessary.


# Registries

## Driver registry

The core of extensibility is implemented as an in-process driver registry. The
things that make it work are:

- Clear priority classes via explicit dependencies. Each drive ris loaded after
  its dependencies are loaded so a driver can assume that all relevant drivers
  of lower level types were fully loaded.
- Native way to skip a driver on unrelated platform.
  - At compile time via conditional compilation.
  - At runtime via early `Init()` exit.
- Native way to return the state of all registered drivers. The ones loaded, the
  ones skipped and the ones that failed.
- Native way to declare inter-driver dependency. A specialized
  processor driver may dependent on a generic one and the drivers will be loaded
  sequentially.
- In another other case, the drivers are loaded in parallel for minimum total
  latency.


## Interface-specific registries

Many packages under [conn](/x/conn/v3) contain interface-specific `XXXreg`
registry as a subpackage. The goal is to not have a one-size-fits-all approach
that would require broad generalization; when a user needs an I²C bus handle,
the user knows they can find it in [conn/i2c/i2creg](/x/conn/v3/i2c/i2creg).
It's is assumed the user knows what bus to use in the first place. Strict type
typing guides the user towards providing the right object. A non exhaustive list
of registries: [gpioreg](/x/conn/v3/gpio/gpioreg), [i2creg]
(/x/periph/conn/i2c/i2creg), [onewirereg](/x/conn/v3/onewire/onewirereg),
[pinreg](/x/conn/v3/pin/pinreg), [spireg](/x/conn/v3/spi/spireg).

The packages follow the `Register()` and `All()` pattern. At
[host.Init()](/x/host/v3#Init) time, each driver registers itself in the
relevant registry. Then the application can query for the available components,
based on the type of hardware interface desired. For each of these registries,
registering the same pseudo name twice is an error. This helps reducing
ambiguity for the users.


# pins

There's a strict separation between [analog](/x/conn/v3/analog#PinIO), [digital
(gpio)](/x/conn/v3/gpio#PinIO) and [generic pins](/x/conn/v3/pins#Pin).

The common base is [pins.Pin](/x/conn/v3/pins#Pin), which is a purely
generic pin. This describes GROUND, VCC, etc. Each pin is registered by the
relevant device driver at initialization time and has a unique name. The same
pin may be present multiple times on a header.

The only pins not registered are the INVALID ones. There's one generic at
[pins.INVALID](/x/conn/v3/pins#INVALID) and two specialized,
[analog.INVALID](/x/conn/v3/analog#INVALID) and
[gpio.INVALID](/x/conn/v3/gpio#INVALID).

*Warning:* analog is not yet implemented.


# Edge based triggering and input pull resistor

CPU drivers can have immediate access to the GPIO pins by leveraging memory
mapped GPIO registers. The main problem with this approach is that one looses
access to interrupted based edge detection, as this requires kernel coordination
to route the interrupt back to the user. This is resolved by to use the GPIO
memory for everything _except_ for edge detection. The CPU drivers has the job
of hiding this fact to the users and make the dual-use transparent.

Using CPU specific drivers enable changing input pull resistor, which sysfs
notoriously doesn't expose.

The setup described above enables the best of both world, low latency read and
write, and CPU-less edge detection, all without the user knowing about the
intricate details!


# Ambient vs opened devices

A device can either be ambient or opened. An ambient device _just exists_ and
doesn't need to be opened. Any other device require an `open()`-like call to get
an handle to be used.

Most operating system virtualizes the system's GPU even if the host system only
has one video card. The application "opens" the video card, effectively its
driver, and ask the GPU device drive rto load texture, run shaders and display
in a window context.

When working with hardware, coordination of multiple users is needed but
virtualization eventually fall short in certain use cases.

Ambient devices are point-to-point single bit devices; GPIO, LED, pins headers.
They are simplistic in nature and normally soldered on the board. They are often
spec'ed by a datasheet. Sharing the device across applications doesn't make
sense yet it is hard to do via the OS provided means.

Opened devices are dynamic in nature. They may or may not be present. They may
be used by multiple users (applications) concurrently. This includes buses and
devices connected to buses.

Using an ambient design is useful for the user because it can be presented by
statically typed global variables. This reduces ambiguity, error checking, it's
just there.

Openable devices permits state, configurability. You can connect a device on a
bus. Multiple applications can communicate to multiple devices on a share bus.
