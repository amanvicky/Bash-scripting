# Bash Scripting — Real Ops Jobs in Plain Bash

Shell-scripting drills from my DevOps course year, kept as written. No framework, no Python crutch — just bash doing actual operations work: installing Tomcat across three OS generations, deploying websites to Apache, fanning commands out over SSH, taking validated backups.

55 `.sh` files. Every non-trivial one below is real: the logs (`websetup/websetup.log` — 600 KB of a live run) are still in the repo.

## The fundamentals — `Bash_Scripts/`

Small drills, one concept each:

- **Variables & quoting** — `VAR2.sh`, `VAR3.sh`, `var1.sh`, `Quotes1.sh` (what single vs double quotes actually protect)
- **Arguments & input** — `args1.sh` (`$#`, `$@`), `read1.sh` (interactive prompt), `testvars.sh`
- **Conditionals** — `if1.sh`–`if4.sh`, `nestedif.sh`
- **Loops** — `for1.sh`–`for3.sh`, `while1.sh`, `while2.sh`
- **Misc** — `arch.sh` (tar/gzip), `print.sh`, `dismantle.sh`

## The real jobs

### One installer, three operating systems — `Bash_Scripts/4_diff_os_tomcat_script/`

`tomcat8_setup.sh` installs Tomcat 8 as a service on CentOS 6, CentOS 7 and Ubuntu 16. The branching is the lesson:

```bash
yum --help > /dev/null 2> /dev/null    # RHEL-family probe
if [ $? -eq 0 ]
then
  if grep -q -i "release 6" /etc/redhat-release   # CentOS 6 → sysvinit
  then SVCFILE=centos6-svcfile
  else SVCFILE=centos7-svcfile                     # CentOS 7 → systemd
  fi
```

Each branch: create the `tomcat` group and a nologin user, `wget $DOWNLOAD_URL`, extract with `--strip-components=1`, fix permissions, then install the matching service file (`chkconfig --add` on 6, `systemctl daemon-reload` on 7/Ubuntu). Tunables live in `vars.txt` (`TOMCAT_HOME`, `DOWNLOAD_URL`). A `Vagrantfile` per target OS, and the Ubuntu variant in `tomcat_scripts_ubuntu/` does the same job with a hand-written systemd unit (`CATALINA_OPTS=-Xms512M -Xmx1024M`).

### Deploy a website to Apache, any distro — `Bash_Scripts/websetup/`

`websetupmulti.sh` detects yum vs apt, installs `httpd`/`apache2` + `wget unzip`, pulls a Tooplate template zip, unpacks it into `/var/www/html/`, restarts the service. `websetup.log` (600 KB) is the actual output of running it — kept as proof it ran, typos and all. `cleanweb.sh` tears the site back off.

### Run one command everywhere — `MultiComRemExec.sh` + `webnodeIP.txt`

```bash
for IP in $(cat webnodeIP.txt); do
  ssh devops@$IP 'free -m; uptime; df -h'
done
```

Poor man's fleet management — read a host list, SSH loop, collect health output. `systemhealth.sh` is the single-host version: free RAM, load average, free space on `/` via `awk` pipelines.

### Backups with exit codes on display — `backup2.sh`, `backup3.sh`

`backup2.sh` archives `$1`, moves the tarball to `$2`, and prints `$#`, `$?`, `$$` and `$SECONDS` at each step — deliberately, so the special variables are visible while they work. `backup3.sh` validates input before acting: `-d` → directory backup, `-e` → file backup, `-z` → refuse empty.

### Watchdog — `scripts/11_monit.sh`

If `/var/run/httpd/httpd.pid` is gone, start `httpd`; if *that* fails, escalate. Nested exit-code checking, the cron-job pattern.

## The course ladder — `scripts/`

The numbered series is the progression from the course: `1_firstscript.sh` → `2_websetup.sh` → `3_vars_websetup.sh` → `4_args.sh` → `5_args_websetup.sh` (same deploy, now parameterized) → `6_command_subs.sh` → `7_userInput.sh` → `8if1.sh`/`9_if1.sh`/`10_ifelif.sh` → `11_monit.sh`/`12_monit.sh` → `13_for.sh`/`14_for.sh` → `15_while.sh`/`16_while.sh`. `scripts/remote_websetup/` is the multi-host version of the web deployer, driven by a `remhosts` file.

## Run it

```bash
git clone https://github.com/amanvicky/Bash-scripting
cd Bash-scripting/Bash_Scripts/websetup
source vars.txt && ./websetupmulti.sh        # on a CentOS or Ubuntu VM
```

Most scripts assume a throwaway VM (the Vagrantfiles in the repo are the intended targets) — several of them install packages and restart services on purpose.

## Kept as written

This is learning-era code on purpose: no `set -euo pipefail`, exit codes echoed instead of enforced, some copy-paste between branches. The honest fix list: fold the repeated install/unzip/restart blocks into functions, make the installers idempotent end to end, and replace the SSH loop with Ansible (which is where my `Python` repo's first playbook picks up). If you want the same deploy logic at higher levels of automation: [cloudformation-practice](https://github.com/amanvicky/cloudformation-practice) does it with cfn-init, [Jenkins-CI-CD](https://github.com/amanvicky/Jenkins-CI-CD) with pipelines, [kubernetes](https://github.com/amanvicky/kubernetes) with objects.
