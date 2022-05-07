Text["es"] = {
    help = {
        title = "Ayuda",
        desc = [[Te doy la bienvenida a <D><b>$modulo$</b></D>! En este módulo podrás explorar variedad de lugares, construir tus propias estructuras y jugar con tus amigos en un enorme mundo bidimensional.
        
<b>Si necesitas ayuda, puedes leer las siguientes pestañas:</b>
<a href='event:controls'>&gt; <u><D>Controles</D>:</u> Cómo jugar el módulo</a>
<a href='event:reports'>&gt; <u><D>Reportes</D>:</u> Errores en el funcionamiento</a>
<a href='event:credits'>&gt; <u><D>Créditos</D>:</u> Personas que han colaborado en $modulo$</a>


¡Espero que te guste!</font>]]
    },
    controls = {
        title = "Controles",
        desc = [[Hay algunos controles y combinaciones de teclas que debes saber para poder jugar <D>$modulo$</D> correctamente. Las teclas que presiones pueden tener distintos efectos según aquello con lo qué estés interactuando, por lo que se enumerarán a continuación:

<u><b><D>En el mundo:</D></b></u>
    - <VP>Click</VP>: Hace daño a lo que cliquees, si está cerca.
    - <D>[SHIFT]</D> + <VP>Click</VP>: Pone un bloque.
    - <D>[CTRL]</D> + <VP>Click</VP>: Interactúa con un bloque (de ser posible).
    - <D>[E]</D>: Abre o cierra el inventario.
    - <D>[1 - 9]</D>: Selecciona una de las ranuras de la barra del inventario.
    - <D>[H]</D>: Abre la pestaña de ayuda.
    - <D>[H]</D> + <D>[K]</D>: Abre la pestaña de Controles.
    - <D>[H]</D> + <D>[R]</D>: Abre la pestaña de Reportes.
    - <D>[H]</D> + <D>[C]</D>: Abre la pestaña de Créditos.

<u><b><D>En el inventario:</D></b></u>
    - <D>[CTRL]</D> + <VP>Click</VP>: Mueve todos los elementos de una ranura a otra.
    - <D>[SHIFT]</D> + <VP>Click</VP>: Mueve un solo elemento de una ranura a otra.
    - <D>[DEL/SUPR]</D>: Elimina todos los elementos de una ranura.
    - <D>[X/Q]</D>: Elimina un solo elemento de una ranura.

- <D>[ALT]</D> + <VP>Click</VP>: Depuración.]]
    },
    reports = {
        title = "Reportes",
        desc = [[¿Has presenciado algo raro ocurriendo en el transcurso del módulo? Si es así, síentete libre de notificarlo y con gusto te atenderé.
        
<b>Para poder arreglar cualquier inconsistencia que reportes, necesitaré que me brindes algo de información:</b>
    - ¿En qué sala jugabas cuando ocurrió? (el nombre)
    - ¿Con cuántas personas jugabas?
    - Si es del mundo, describe el lugar en el que te encontrabas.
    - Describe todas las cosas que hicistes momentos antes de que ocurriese
    
<b><ROSE>/!\</ROSE> ¡Por favor, comunícate en inglés o español, de lo contrario no te podré entender! <ROSE>/!\</ROSE></b>

Una vez me proporciones estos datos, yo, el desarrollador del módulo ($username$) intentaré arreglar el error lo antes posible. Para contactarme, puedes acudir a una de las siguientes vías:
    - A través de <BL>Discord</BL>: $discord$.
    - En conversaciones del <V>foro</V>: $username$
    - Por <CEP>susurros</CEP>: <O>/c $username$</O> <CEP>Hola!</CEP>


Así también, puedes contactarme por cualquier duda o pregunta y sugerencia que tengas y te atenderé :P]]
    },
    credits = {
        title = "Créditos",
        desc = "Creador: <a href='event:profile-$creator$'>$creator$</a>"
    },
    alerts = {
        death = "¡Has muerto!",
        respawn = "Has clic para revivir",
        too_far = "Estás demasiado lejos para interactuar con $object$."
    },
    modulo = {
        timeout = "Módulo en Espera..."
    },
    errors = {
        physics_destroyed = "Sistema de colisiones destruído: <CEP>Límite de objetos físicos superado:</CEP> <R>$current$/$limit$</R>.",
        worldfail = "Fallo en la carga del mundo."
    }
}
