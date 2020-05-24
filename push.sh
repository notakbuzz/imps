#!/bin/sh

echo "#+++++++++++++++++++++++++++++"
echo "#############################################"
echo "Hey there nigga!!"
echo "This script helps pushing big repos with heavy commits in the batch of 2000 commits interactively."
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "MAKE SURE TO USE SSH, ELSE YOU'LL KEEP ENDING ENTERING PASSWORD FOR EVERY COMMIT PUSH IN THE LOOP"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "#############################################"
echo "++++++++++++++++++++++++++++++"

echo ""

echo "***************************"
echo "Let's begin the shit....."
echo "***************************"

echo ""


echo "******************************"
echo "Source URL"
echo "******************************"
echo ">> Select 1 or 2"
echo "******************************"
echo "1) If trying the push for the first time."
echo "2) If encountered any error in between while running this script, no worries. Just change the working directory."
echo "******************************"
echo "Enter 1 or 2: "; read choice1
echo "******************************"

case $choice1 in
1)
# Ask the user to clone the repo
echo "***************************"
echo "Enter the user/org name to be cloned from: "
echo "#Note: user/org name same as on github."
echo "***************************"
echo ""
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "USER/ORG_NAME: "; read uoname
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo ""
echo "***************************"
echo "User/Org name saved!"
echo "***************************"
echo ""
echo "***************************"
echo "Enter the repo name to be cloned: "
echo "#Note: repo_name same as on github."
echo "***************************"
echo ""
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "REPO_NAME: "; read name
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo ""
echo "***************************"
echo "Repo name saved!"
echo "***************************"
echo ""

#echo "***************************"
#echo "Enter the repo url to be pushed: "
#echo "#Note: Make sure to clone using ssh, else keep entering password sur!"
#echo "*example: git@github.com:usr_name/repo_name.git"
#echo ""
#echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
#echo "REPO_URL: "; read url
#echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<"
#echo ""
#echo "***************************"
#echo "Repo url saved!"
#echo "***************************"

#echo ""

# clone the repo
echo "***************************"
echo "Cloning the repo $uoname/$name..."
echo "***************************"
git clone git@github.com:$uoname/$name.git
echo "***************************"
echo "Repo $uoname/$name cloned!"
echo "***************************"
echo ""
# change working directory to the cloned repo
echo "***************************"
echo "Changing the working directory..."
echo "***************************"
echo ""
cd $name
echo "***************************"
echo "Working directory changed to: "
echo "***************************"
echo ""
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
pwd
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo ""
;;
2)
echo "Enter the repo name already cloned: "
echo "#Note: repo_name same as you entered while pushing for the first time."
echo "***************************"
echo ""
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "REPO_NAME: "; read name
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo ""
echo "***************************"
echo "Repo name saved!"
echo "***************************"
echo ""
# change working directory to the cloned repo
echo "***************************"
echo "Changing the working directory..."
echo "***************************"
echo ""
cd $name
echo "***************************"
echo "Working directory changed to: "
echo "***************************"
echo ""
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
pwd
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo ""
echo "***************************"
;;
*)
echo "Nothing is here... Go away!"
;;
esac

echo ""

# Ask the user for the destination repo url
echo "******************************"
echo "Destination URL"
echo "******************************"
echo ">> Select 1 or 2"
echo "******************************"
echo "1) If trying the push for the first time."
echo "2) If encountered any error in between while running this script, no worries. We won't ask you again for the DESTINATION details."
echo "******************************"
echo "Enter 1 or 2: "; read choice0
echo "******************************"

case $choice0 in
1)
echo "***************************"
echo "Enter the destination repo user/org name: "
echo "#Note: user/org name of the repo where you want the base repo to be cloned."
echo "#Note: Make sure to use ssh, else keep entering password sur!"
echo "*example: git@github.com:(usr/org_name)/repo_name.git"
echo "Enter usr/org name! [without the brackets ()!!]"
echo ""
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "DESTINATION_USER/ORG_NAME: "; read duoname
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo ""
echo "***************************"
echo "Destination user/org name saved!"
echo "***************************"
echo ""
echo "***************************"
echo "Enter the destination repo name: "
echo "#Note: repo url where you want the repo to be cloned."
echo "#Note: Make sure to use ssh, else keep entering password sur!"
echo "*example: git@github.com:usr_name/repo_name.git"
echo "Enter repo_name!"
echo ""
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "DESTINATION_NAME: "; read dname
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo ""
echo "***************************"
echo "Destination repo name saved!"
echo "***************************"
echo ""

# change origin remote url
echo "***************************"
echo "Changing the origin remote url..."
git remote set-url origin git@github.com:$duoname/$dname.git
echo ""
echo "Origin remote successfully changed!"
echo "***************************"
echo ""
echo "***************************"
echo "Verify the remote: "
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
git remote -v
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<"
;;
2)
echo "Saved DESTINATION_USER/ORG_NAME: $duoname DESTINATION NAME: $dname"
echo "***************************"
echo "Verify the remote: "
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
git remote -v
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<"
;;
*)
echo "Nothing is here... Go away!"
;;
esac

echo ""


echo "******************************"
echo "Switch Branch"
echo "******************************"
echo ">> Select 1 or 2"
echo "******************************"
echo "1) If trying the push for the first time."
echo "2) If encountered any error in between while running this script, no worries. Just verify the current branch."
echo "******************************"
echo "Enter 1 or 2: "; read choice2
echo "******************************"
echo ""
case $choice2 in
1)
# Ask the user to checkout to a new branch
echo "***************************"
echo "Time to switch to new branch! :>"
echo "***************************"
echo ""
echo "***************************"
echo "Enter the new branch name: "
echo "***************************"
echo ""
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "BRANCH_NAME: "; read bname
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo ""
echo "***************************"
echo "Checking out to the new branch : $bname..."
echo "***************************"s
echo ""
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
git checkout -b $bname
echo "Branch successfully checked out to $bname!"
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo ""
echo "***************************"
echo "Verify the branch: "
echo "***************************"
echo ""
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
git branch -v
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo ""
;;
2)
echo "***************************"
echo "Verify the branch: "
echo "***************************"
echo ""
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>"
git branch -v
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo ""
;;
*)
echo "Nothing is here... Go away!"
;;
esac

echo ""

echo "%%%%%%%%%%%%%%%%%%%%"
echo "Time to push nigga!!"
echo "%%%%%%%%%%%%%%%%%%%%"

# Adjust the following variables as necessary
REMOTE=origin
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# check if the branch exists on the remote
if git show-ref --quiet --verify refs/remotes/$REMOTE/$BRANCH; then
    # if so, only push the commits that are not on the remote already
    range=$REMOTE/$BRANCH..HEAD
else
    # else push all the commits
    range=HEAD
fi

# delete non-existent ref
echo ""
echo "**********************************"
echo "Deleting non-existent reference..."
echo "**********************************"
echo ""
echo "******************************"
echo ">> Select 1 or 2"
echo "******************************"
echo "1) If trying the push for the first time."
echo "2) If encountered any error in between while running this script, no worries. We'll try fixing it..."
echo "******************************"
echo "Enter 1 or 2: "; read choice
echo "******************************"
case $choice in
	1)
	git push $REMOTE :refs/heads/$BRANCH
	;;
	2)
	#git push -f $REMOTE :refs/heads/$BRANCH
	echo "Everything seems good! Lets continue..."
	;;
	*)
	echo "Nothing is here... Go away!"
	;;
esac
echo "******************************"

# count the number of commits to push
count=$(git log --first-parent --oneline --format=format:%H $range | wc -l)

echo ""
echo "****************************"
echo "Pushing to branch $BRANCH..."
echo "****************************"
echo ""

# push each batch
for i in $(seq $count -2000 1); do
    # get the hash of the commit to push
    hash=$(git log --first-parent --reverse --oneline --format=format:%H --skip $i -n1)
    echo ""
    echo "***************************"
    echo "Pushing commit: $hash..."
    echo "remote_name: $REMOTE & branch_name: $BRANCH!!"
    echo "***************************"
    echo ""
    echo "***************************"
    git push $REMOTE $hash:refs/heads/$BRANCH
    echo "***************************"
done

echo ""

# push the final partial batch
echo "***************************"
git push $REMOTE HEAD:refs/heads/$BRANCH
echo "***************************"

echo ""
