> Resoultion Notes

- Godots default resolution is 1024 x 600
- 320x180 
- 400x225 (Based on Shovel Kinght's res to fit 16:9)
- 480x270 (Based on Hyper Light Drifter's res)
- 640x360 
- 1280x720
Pixel Perfect Scaling thread:
https://github.com/godotengine/godot/issues/6506


> Game Notes (Improvements)
-  Enemy AI
- Make GUI enemy planes more obvious (maybe add an enemy word or something) as they might be misunderstood as lives.
- Enemy spawn rate doesn't reset when apples do. Both should reset, i guess.
- Optimize game (sometimes it gets slow)
- Cloud parallax over and below (maybe 3 or 4 layers)
- Maybe clouds could be used as cover for the towers. 
- Modify tower to feel like they are searching on the sky (using a circle with cone perspective maybe?)
- Cool typical plane maneuver


> GIT

download:
git pull

push!
git push

create and work on branch:
git checkout -b branch_name

finished? now commit and PR
git add *
git commit -a
git push origin branch_name

after PR succesfully merged, delete branch
git branch -d branch_name
