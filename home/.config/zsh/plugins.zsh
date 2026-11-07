# {{ ansible_managed }}
# Versions are owned by ansible/roles/zsh/defaults/main.yml.
{% for plugin in zsh_plugins %}
zplug '{{ plugin.name }}', at:{{ plugin.version }}{{ (', ' ~ (plugin.options | join(', '))) if plugin.options else '' }}
{% endfor %}
