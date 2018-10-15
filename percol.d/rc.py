percol.view.__class__.PROMPT = property(
        lambda self:
        ur"<bold><red>QUERY </red>[a]:</bold> %q" if percol.model.finder.case_insensitive
        else ur"<bold><green>QUERY </green>[A]:</bold> %q"
)

percol.view.CANDIDATES_LINE_BASIC    = ("on_default", "default")
percol.view.CANDIDATES_LINE_SELECTED = ("underline", "on_red", "white")
percol.view.CANDIDATES_LINE_MARKED   = ("bold", "on_cyan", "black")
percol.view.CANDIDATES_LINE_QUERY    = ("yellow", "bold")
