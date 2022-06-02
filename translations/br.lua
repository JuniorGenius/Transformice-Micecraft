Text["br"] = inherit(Text["xx"], {
    help = {
        title = "Ajuda",
        desc = [[Bem vindo(a) a <D><b>$modulo$</b></D>! Neste module você pode explorar uma grande variedades de lugares, construa suas construções e jogue com seus amigos em um grande mundo bimendisional.
        
<b>Se você precisar de ajuda, você pode checar as abas:</b><D>
<a href='event:controls'>&gt; <u><D>Controles</D>:</u> Como jogar</a>
<a href='event:reports'>&gt; <u><D>Reportes</D>:</u> Mal funcionações no jogo</a>
<a href='event:credits'>&gt; <u><D>Creditos</D>:</u> Pessoas que coloboraram em $modulo$</a>


Espero que goste !]]
    },
    controls = {
        title = "Controles",
        desc = [[Existe várias combinações de teclas que você precisa pra joga o <D>$modulo$</D> devidamente. As teclas que você pressiona tem efeitos diferentes dependendo do lugar que você esta. Aqui temos as teclas enumeradas:

<u><b><D>No mundo:</D></b></u>
    - <VP>Click</VP>: Danifica qualquer coisa que você clica, se perto.
    - <D>[SHIFT]</D> + <VP>Click</VP>: Colaca um bloco.
    - <D>[CTRL]</D> + <VP>Click</VP>: Interage com os blocos (se possível).
    - <D>[E]</D>: Abre ou fecha o inventário.
    - <D>[1 - 9]</D>: Selecione um slot da hotbar.
    - <D>[H]</D>: Abre a janela de ajuda.
    - <D>[H]</D> + <D>[K]</D>: Abre a janela de teclas.
    - <D>[H]</D> + <D>[R]</D>: Abre a janela de reporte.
    - <D>[H]</D> + <D>[C]</D>: Abre a janela de creditos.

<u><b><D>No inventário:</D></b></u>
    - <D>[CTRL]</D> + <VP>Click</VP>: Move todos objetos de um slot para o outro.
    - <D>[SHIFT]</D> + <VP>Click</VP>: Apenas move um objeto para outro slot.
    - <D>[DEL/SUPR]</D>: Deleta todos objetos de um slot.
    - <D>[X/Q]</D>: Apenas deleta um objeto.

- <D>[ALT]</D> + <VP>Click</VP>: Debug.]]
    },
    reports = {
        title = "Reportes",
        desc = "Se você achar, por favor comunique comigo, através do forum ($username$) No mu discord em menssagens diretas: $discord$."
    },
    credits = {
        title = "Creditos",
        desc = "Criador: <a href='event:profile-$creator$'>$creator$</a>\n\nTradutor: Sklag#2552"
    },
    alerts = {
        death = "Você morreu!",
        respawn = "Clique pra spawnar!",
        too_far = "Você esta muito longe de $object$."
    },
    modulo = {
        timeout = "Module em Esgotamento..."
    },
    errors = {
        physics_destroyed = "Sistema de fisica destruido: <CEP>Limite de objetos fisicos alcançado:</CEP> <R>$current$/$limit$</R>.",
        worldfail = "Falha no carregamento do mundo."
    },
    loading = {
        new = {
            world = "Generando Novo Mundo"
        },
        loading = "Carregando"
    }
})