# bt-target

## Info
Since the original is no longer maintained and pull requests are not looked at this will be a maintained fork, feel free to contribute to this one as pull requests and issues will be actively checked.

## Credits
- [brentN5](https://github.com/brentN5) - Original Author
- [Mojito-Fivem](https://github.com/Mojito-Fivem) - Contributor and Active Maintainer
- [TheeDeer](https://github.com/TheeDeer) - Contributed Vehicle Bone Support


## Dependencies
- [Polyzone](https://github.com/mkafrin/PolyZone)
- [Icons](https://fontawesome.com)

## Description

Here a simple target tracking script that tracks where your player is looking at. Coords and models can be used. You can add multiple payphone models for example and when your player looks at it. It activates the UI to trigger an event. Polyzones can be used also. Its uses 0.00 ms (0.16% CPU Time) when idle. This can be used in multiple scripts to help with optimisation. Press ALT to activate. Using RegisterKeyMapping removes the need of checking if key has been pressed in a thread and players can customise the keybind in the ESCAPE menu. You can also create multiple options per target. Read the example to learn how to use it.

## Examples

```lua
Citizen.CreateThread(function()
    local peds = {
        `a_f_m_bevhills_02`,
    }
    AddTargetModel(peds, {
        options = {
            {
                event = "Random 1event",
                icon = "fas fa-dumpster",
                label = "Random 1",
            },
            {
                event = "Random 2event",
                icon = "fas fa-dumpster",
                label = "Random 2",
            },
            {
                event = "Random 3event",
                icon = "fas fa-dumpster",
                label = "Random 3",
            },
            {
                event = "Random 4event",
                icon = "fas fa-dumpster",
                label = "Random 4",
            },
        },
        job = {"garbage"}
        distance = 2.5
    })

    local coffee = {
        690372739,
    }
    AddTargetModel(coffee, {
        options = {
            {
                event = "coffeeevent",
                icon = "fas fa-coffee",
                label = "Coffee",
            },
        },
        job = {"all"}
        distance = 2.5
    })
    
    AddBoxZone("PoliceDuty", vector3(441.79, -982.07, 30.69), 0.4, 0.6, {
	name="PoliceDuty",
	heading=91,
	debugPoly=false,
	minZ=30.79,
	maxZ=30.99
    }, {
        options = {
            {
                event = "signon",
                icon = "far fa-clipboard",
                label = "Sign On",
            },
            {
                event = "signoff",
                icon = "far fa-clipboard",
                label = "Sign Off",
            },
        },
        job = {"police", "ambulance", "mechanic"},
        distance = 1.5
    })
    
    -- Bone support added by @TheeDeer on github
    AddTargetBone(bones, {
	options = {
	    {
		event = "door",
		icon = "fas fa-door-open",
		label = "Toggle Door",
	    },
	    {
		event = "unlock",
		icon = "fas fa-door-open",
		label = "Unlock Door",
	    },
	},
	job = {"police", "ambulance", "mechanic"},
	distance = 1.5
    })
end)
```
