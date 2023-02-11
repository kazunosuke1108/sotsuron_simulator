function data = git_auto_pull()

try
    !git pull
catch
    !git add .
    !git commit -m "AutoPush"
    !git pull origin main
    !git push origin main

end