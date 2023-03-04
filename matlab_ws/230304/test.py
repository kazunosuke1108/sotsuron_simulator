import os
import subprocess
pwd=subprocess.run("whoami", capture_output=True, text=True)
pwd=pwd.stdout.replace("\n", "")
print(pwd)
print(os.environ['HOME'])