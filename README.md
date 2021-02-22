# bt-target
 
Dependencies: https://github.com/mkafrin/PolyZone

Icons: https://fontawesome.com/

Here a simple target tracking script that tracks where your player is looking at. Coords and models can be used. You can add multiple payphone models for example and when your player looks at it. It activates the UI to trigger an event. Polyzones can be used also. Its uses 0.00 ms (0.16% CPU Time) when idle. This can be used in multiple scripts to help with optimisation. Press ALT to activate. Using RegisterKeyMapping removes the need of checking if key has been pressed in a thread and players can customise the keybind in the ESCAPE menu.

Example: 

```
Citizen.CreateThread(function()
    local bins = {
        `prop_bin_01a`,
        `prop_dumpster_4b`,
        `prop_skip_08a`,
    }
	AddTargetModel(bins, {
		event = "binevent",
		icon = "fas fa-dumpster",
		label = "A Bin",
		radius = 1.5
	})

	AddBoxZone("PoliceDuty", vector3(441.79, -982.07, 30.69), 0.4, 0.6, {
		name="PoliceDuty",
		heading=91,
		debugPoly=false,
		minZ=30.79,
		maxZ=30.99
    }, {
		event = "dutyevent",
		icon = "far fa-clipboard",
		label = "Duty",
		distance = 1.5
	})
end)
```