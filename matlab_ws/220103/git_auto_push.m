function data = git_auto_push()

try
    !git add .
    !git commit -m "AutoPush"
    !git push origin main
catch
    !git add .
    !git commit -m "AutoPush"
    !git pull origin main
    !git push origin main

end