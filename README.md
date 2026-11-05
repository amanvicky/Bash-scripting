# Bash Scripting — 87 Scripts

Shell scripting practice with a bias for scripts that do real ops work.

## Highlights

- **`4_diff_os_tomcat_script/`** — idempotent Tomcat 8 installer that adapts to CentOS 6/7 and Ubuntu 16 (service files, vars, Vagrantfile for each target)
- **`MultiComRemExec.sh`** — run commands across multiple remote hosts
- **`backup2.sh` / `backup3.sh`** — incremental + compressed backup jobs
- **`arch.sh`, `args1.sh`, `VAR2.sh`, `Quotes1.sh`** — the fundamentals: variables, quoting, args, archives

## Run

```bash
git clone https://github.com/amanvicky/Bash-scripting
cd Bash-scripting/Bash_Scripts
chmod +x backup3.sh && ./backup3.sh /path/to/data
```

87 `.sh` files total — greps, sed/awk one-liners, cron-style automation, user-management drills.
