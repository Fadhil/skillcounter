SkillCounter README
===================

SkillCounter is an online Points tracker for system the Malaysian Veterinary Council. Users (Veterinarians) can claim their profile to begin tracking the events/courses they attend and the points gained from them. Admins (MVC) is able to view User details and participations as well as points. Organizers (Event Organizers, internal and 3rd party) can manage their events and view participation of said events. 


Ruby version
------------
ruby-2.1.4

How to clone onto C9
-------------------
Open up your Dashboard. Create new Workspace. Choose 'Custom'. Give it the name "SkillCounter". 
Once your workspace is loaded, type :
	`git init`
	`git remote add origin git@github.com:Fadhil/skillcounter.git`
	`git pull --rebase origin master`

	** Note: You might need to add your cloud9 SSH keys to your github account You can get your
	cloud9 ssh keys by typing this:**

	`less ~/.ssh/id_rsa.pub`

	Copy the output and add it to your Github account under "Settings->Deploy Keys"

