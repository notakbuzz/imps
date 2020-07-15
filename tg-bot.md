😬 How to Deploy your UserBot to Heroku?

YOU ABSOLUTELY MUST READ THE ENTIRE STEPS, AND NOT SKIM THROUGH ANY OF IT!
```bash
👉 Install this application from Google Play

👉 Open Termux

👉 termux-setup-storage

👉 pkg install python git

 apt install git python -y && pip install telethon

👉 python -m venv venv && . ./venv/bin/activate

👉 cd /sdcard/Telegram

👉 git clone https://github.com/Dark-Princ3/X-tra-Telegram

👉 cd X-tra-Telegram

👉 pip install telethon

👉 python3 telesetup.py

👉 Follow the OnScreen prompts

👉 https://GenerateStringSession.morgue.repl.run

N.B.: Keep this string safe! Anyone with this string can use it to login into your account and do anything they want to to do.
```

```bash
👉 Open this link

👉 Follow the OnScreen prompts

👉 App name, APP_ID, API_HASH, STRING_SESSION, TG_BOT_TOKEN_BF_HER and TG_BOT_USER_NAME_BF_HER are mandatory fields. Rest of the fields can be left with the default values.

👉 Tap on Deploy app

👉 Wait for deploy to finish.

👉 After deploy press Manage App then go to Resources

👉 Enable the worker dyno, by toggling the slide-toggle.

👉 Done. Your UserBot is alive. Check with .help in any chat.
```

```bash
APP_ID : 1246043
API_HASH : 4b1a32f9d2361dac527ebeda29c40b66
ALIVE_NAME : @bun_nyy
GITHUB_ACCESS_TOKEN : 8632c002a6ec28d14e5e79d74c7ddc35bfea325a
GITHUB_REPO_NAME : $URL https://github.com/BunsExynos/tg
HEROKU_APP_NAME : $NAME
HEROKU_API_KEY : /account 993d1807-3f60-4602-a51c-21467cd9a9e1
PRIVATE_GROUP_ID : .get_id -1001490644363
PRIVATE_GROUP_BOT_API_ID : .get_id -1001490644363
TG_BOT_TOKEN_BF_HER : 1243721790:AAFEvMUWrPAnqR6UmdSXLLIg8Urv3_oqM8M
TG_BOT_USER_NAME_BF_HER : @StormPooperBot
STRING_SESSION : generate string 
```
