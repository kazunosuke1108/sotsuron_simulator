function data = git_auto_push(msg)

try
    !git add .
    !git commit -m "AutoPush:{msg}"
    !git push origin main
catch
    !git add .
    !git commit -m "AutoPush:{msg}"
    !git pull origin main
    !git push origin main

end