{ config, pkgs, ... }:

let
  cfg = config.nielx;
  screen = "${pkgs.screen}/bin/screen";
in
{
  environment.systemPackages = [
    # Requires $MAILDIR to be set.
    (pkgs.writeScriptBin "checkmail" ''#!/bin/sh
echo "Email: $(ls $MAILDIR/INBOX/new | wc -l)"
'')

    # Used when reading HTML emails from mutt to avoid the temporary HTML files
    # being deleted before Firefox gets a chance to load them.
    (pkgs.writeScriptBin "firefox-wait" ''#!/bin/sh
${pkgs.firefox}/bin/firefox "$1"
sleep 3
'')

    (pkgs.writeScriptBin "mail" ''#!/bin/sh
if ${screen} -list | grep mutt | grep -q Detached; then
    ${screen} -r mutt
elif ${screen} -list | grep mutt | grep -q Attached; then
    ${pkgs.neomutt}/bin/neomutt -R
else
    ${screen} -S mutt ${pkgs.neomutt}/bin/neomutt
fi
'')

    (pkgs.writeScriptBin "mailget" ''#!/bin/sh
if ${screen} -list | grep offlineimap | grep -q Detached; then
    ${screen} -r offlineimap
elif ${screen} -list | grep offlineimap | grep -q Attached; then
    echo 'error: offlineimap already running'
else
    ${screen} -S offlineimap ${pkgs.offlineimap}/bin/offlineimap
fi
'')

    (pkgs.writeScriptBin "sendmail-test" ''#!/${pkgs.python3}/bin/python3
import smtplib
from email.mime.text import MIMEText

def send_email(address_from, address_to, subject, body):
    msg = MIMEText(body)
    msg['Subject'] = subject
    msg['From'] = address_from
    msg['To'] = address_to
    s = smtplib.SMTP('localhost')
    s.send_message(msg)
    s.quit()

if __name__ == '__main__':
    send_email('test@${cfg.www.domain}', '${cfg.email}', 'Test', 'Test test.')
'')
  ];
}
