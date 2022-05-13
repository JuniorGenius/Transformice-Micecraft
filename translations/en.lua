Text["en"] = {
    help = {
        title = "Help",
        desc = [[Welcome to <D><b>$modulo$</b></D>! In this module you will be able to explore variety of places, build your own structures and play with your friends in a vast bidimensional world.

<b>If you need help, you can check the following tabs:</b>
<a href='event:controls'>&gt; <u><D>Controls</D>:</u> How to play the module</a>
<a href='event:reports'>&gt; <u><D>Reports</D>:</u> Malfunctionings in the game</a>
<a href='event:credits'>&gt; <u><D>Credits</D>:</u> People that have colaborated in $modulo$</a>


Hope you enjoy!]]
    },
    controls = {
        title = "Controls",
        desc = [[There are some controls and keys combinations that you must know in order to play <D>$modulo$</D> properly. The keys you press might have different effects depending on what are you interacting with. Next here they're enumerated as:

<u><b><D>In the world:</D></b></u>
    - <VP>Click</VP>: Damages anything you click, if nearby.
    - <D>[SHIFT]</D> + <VP>Click</VP>: Puts a block.
    - <D>[CTRL]</D> + <VP>Click</VP>: Interacts with a block (if possible).
    - <D>[E]</D>: Opens or closes the inventory.
    - <D>[1 - 9]</D>: Selects a slot from the hotbar.
    - <D>[H]</D>: Opens the Help tab.
    - <D>[H]</D> + <D>[K]</D>: Opens the Controls tab.
    - <D>[H]</D> + <D>[R]</D>: Opens the Reports tab.
    - <D>[H]</D> + <D>[C]</D>: Opens the Credits tab.

<u><b><D>In the inventory:</D></b></u>
    - <D>[CTRL]</D> + <VP>Click</VP>: Moves all the elements from one slot to another.
    - <D>[SHIFT]</D> + <VP>Click</VP>: Moves only one element from one slot to another.
    - <D>[DEL/SUPR]</D>: Deletes all the elements from one slot.

- <D>[ALT]</D> + <VP>Click</VP>: Debug.]]

    },
    reports = {
        title = "Reports",
        desc = [[Have you witnessed something weird happening in the course of the module? If you did, feel free to notify it and I'll glady take your case.
        
<b>To be able to fix any inconsistence that you report, I'll need you to bring some information:</b>
    - What room where you playing on when it happened? (its name)
    - How many people where you playing with?
    - If it's about the world, describe the place on where you were in.
    - Describe all the things you were doing moments before the incident
    
<b><ROSE>/!\</ROSE> Please, communicate in english or spanish, or either I will not be able to understand you! <ROSE>/!\</ROSE></b>

Once you bring me these info, I, the developer of the module ($username$) will try to fix the error as soon as possible. To contact me, you can resort to one of the following ways:
    - Through <BL>Discord</BL>: $discord$.
    - In <V>Forum's</V> conversations: $username$
    - On <CEP>whispers</CEP>: <O>/w $username$</O> <CEP>Hey!</CEP>


You can also contact me if you have any question and if you want to suggest something too and I'll attend you :P]]
    },
    credits = {
        title = "Credits",
        desc = "Creator: <a href='event:profile-$creator$'>$creator$</a>"
    },
    alerts = {
        death = "You've died!",
        respawn = "Click to respawn",
        too_far = "You're too far to interact with $object$."
    },
    modulo = {
        timeout = "Module on Timeout..."
    },
    errors = {
        physics_destroyed = "Physic system destroyed: <CEP>Limit of physic objects reached:</CEP> <R>$current$/$limit$</R>.",
        worldfail = "World loading failure."
    },
    debug = {
        left = [[<b>$module$</b>
Ticks: 549 ms

<b>Chunks</b>
Loaded: %d
Activated: %d

Global Grounds: %d/%d

<b>Gravity Forces:</b>
Wind: %d
Gravity: %d

<b>Player - %s</b>
Lang: %s
TFM XY: %d / %d
MC XY: %d / %d
facing: (%s)
Current Chunk: %d (%s)
Last Chunk: %d]],
        right = [[Clock Time:
%d s

<b>Update Status</b>
LuaAPI: %s
Revision: %s
Tfm: %s
Revision: %s
Lastest: %s

Stress: %d/%d ms
(%d ms)

Active Events: %d]]
    }
}

