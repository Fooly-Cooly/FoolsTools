By default, Windows uses the restricted Powershell script
execution policy, preventing execution of any Powershell script.
Only members of the Administrators group can change the execution
policy. By doing the following, it will allow running unsigned
scripts that you write on your local computer and signed internet scripts.

1. Start Windows PowerShell with "Run as Administrator".

2. Enter "Set-ExecutionPolicy RemoteSigned" without quotes.
   Enter "Set-ExecutionPolicy Restricted" without quotes to revert back.