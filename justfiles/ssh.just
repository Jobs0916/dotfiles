
# Crea un email
create email:
    @ssh-keygen -t ed25519 -C "{email}"

# Genera un agente
agent:
    eval "$(ssh-agent -s)"

# Copiar al clipboard
copy:
    pbcopy < ~/.ssh/id_ed25519.pub
