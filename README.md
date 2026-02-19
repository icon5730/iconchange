🖼️ <b>Iconchange — Firefox & Thunderbird Icon Customizer</b>

Easily change or restore the application icons for Firefox and Thunderbird on Linux by modifying their .desktop launcher files in /usr/share/applications/.

![iconch](https://github.com/user-attachments/assets/be8062c5-54d1-4daf-bc06-096cca7a54b8)


| Iconchange is a Bash utility that: |
|------------------|
| `✔ Changes Firefox or Thunderbird icon to a custom image` |
| `✔ Restores default icons` |
| `✔ Validates file type and path` |
| `✔ Handles multiple Firefox/Thunderbird variants` |
| `✔ Installs as a system command (iconchange)` |




| Supports multiple Firefox builds: |
|------------------|
| 'firefox" |
| 'firefox-beta' |
| 'firefox-esr' |
| 'firefox-nightly' |
| 'firefox-developer' |
|------------------|
| Supports multiple Thunderbird builds: |
|------------------|
| 'thunderbird' |
| 'thunderbird-daily' |
| 'thunderbird-esr' |
| 'thunderbird-nightly' |
|------------------|
| Accepts icon formats |
|------------------|
| 'PNG' |
| 'JPG / JPEG' |
| 'BMP' |
| 'ICO' |



| Accepts icon formats: |
|------------------|
| `PNG` |
| `JPG / JPEG` |
| `BMP` |
| `ICO` |


| Flag | Description |
|------|------------|
| `-f` | Change Firefox icon |
| `-t` | Change Thunderbird icon |
| `-r` | Restore default |
| `-l` | Install command |
| `-R` | Remove command |
| `-h` | help menu |


<b>Installation:</b>

```bash
git clone https://github.com/<user>/iconchange.git
cd iconchange
chmod +x iconchange.sh
```

<b>Usage:</b>

```bash
./iconchange.sh [options]
```

or if installed as a global command:

```bash
iconchange [options]
```

<b>Flag	Argument	Description:</b>
