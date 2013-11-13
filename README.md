fetchmail_testing
=================

Testing fetchmailrc


This is not an RT specific process but many RT users are also fetchmail users.


The basic idea is to dump your fetchmailrc to JSON and verify it with a Perl testscript.

1. Dump fetchmailrc to a Python data structure using %>fetchmail --configdump -f fetchmailrc > fetchmailrc.py
1. Convert Python data structure to JSON. %>python fetchmail.py > fetchmailrc.py.json
1. prove -v t/test.t :: fetchmailrc.py.json
