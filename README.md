# bt-target
 
Dependencies: https://github.com/mkafrin/PolyZone

Icons: https://fontawesome.com/

Here a simple target tracking script that tracks where your player is looking at. Coords and models can be used. You can add multiple payphone models for example and when your player looks at it. It activates the UI to trigger an event. Polyzones can be used also. Its uses 0.00 ms (0.16% CPU Time) when idle. This can be used in multiple scripts to help with optimisation. Press ALT to activate. Using RegisterKeyMapping removes the need of checking if key has been pressed in a thread and players can customise the keybind in the ESCAPE menu. You can also create multiple options per target. Read the example to learn how to use it.

**PhilsBadMan**

Edit to allow passing of arguments in events.
In this example I pass the model and object with the event

To Trigger:

```lua
options = {
            {
                event = "banking:atm",
                icon = "fas fa-piggy-bank",
                label = "Use ATM",
                args = true,
            },
            {
                event = "banking:hack",
                icon = "fas fa-piggy-bank",
                label = "Hack ATM",
                args = false,
            },
        },
```
