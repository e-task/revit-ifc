Dieser Ordner enthält die Hooks für dieses Git-Repository. Die Hooks führen vor dem lokalen Commit in dieses Repo bestimmte Prüfungen durch, die wir als Entwickler gemeinsam festgelegt haben. Die Aktivierung der Hooks auf dem lokalen Entwickler-Rechner ist nicht zentral möglich.

Die Hooks sind in Powershell geschrieben und somit auf euren Windows-Rechner lauffähig.

Zur Aktivierung der Hooks auf eurem Rechner müsst ihr die folgenden Befehle in dem Root Ordner dieses Repos in eurem Terminal ausführen:

Für Windows:

```shell
Copy-Item .githooks\commit-msg-win .git\hooks\commit-msg
```

Für Linux:

```shell
chmod 777 ./.githooks/CheckCommitMessage.sh
cp ./.githooks/commit-msg-linux ./.git/hooks/commit-msg
chmod 777 ./.git/hooks/commit-msg
chmod +x ./.git/hooks/commit-msg
```
