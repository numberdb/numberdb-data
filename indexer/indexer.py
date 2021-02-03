#Run this from numberdb-data working directory.

from git import Repo
import yaml
import os

def update_ids():

	repo = Repo("./") #numberdb-data repository
	if repo.bare:
		raise ValueError("repository is bare")
	if repo.is_dirty():
		raise ValueError("repository is dirty")  # check the dirty state
	#repo.untracked_files             # retrieve a list of untracked files


	reader = repo.config_reader()             # get a config reader for read-only access
	#with repo.config_writer():       # get a config writer to change configuration
	#    pass                         # call release() to be sure changes are written and locks are released

	head = repo.head
	commit = head.commit
	tree = commit.tree

	#r = repo
	#h = repo.head
	#c = h.commit
	#t = c.tree
	index = repo.index
	#i = index

	next_ids_filename = os.path.join("data","next_ids.yaml")
	collection_id_prefix = "C"

	def succ_id(id):
		prefix = id[0]
		#number = ZZ(id[1:])
		number = int(id[1:])
		return "%s%s" % (prefix, number+1)

	try:
		with open(next_ids_filename,"r") as f:
			next_ids = yaml.load(f,Loader=yaml.BaseLoader)
			next_collection_id = next_ids["next_collection_id"]
			
	except FileNotFoundError:
		next_collection_id = collection_id_prefix + "0"

	print("next_collection_id:",next_collection_id)

	commit_message = "added ids\n\n"
	new_collection_paths = []

	for item in tree.traverse():
		if item.type == 'blob':
			path, filename = os.path.split(item.path)
			if filename == "collection.yaml":
				if not os.path.exists(os.path.join(path,"id.yaml")):
					new_collection_paths.append(path)

	print("new_collection_paths:",new_collection_paths)

	new_filenames = []

	for path in new_collection_paths:
		filename = os.path.join(path,"id.yaml")
		with open(filename,"w") as f:
			f.writelines([
				"# Automatically created file. Do NOT edit.\n",
				"# If you copy the containing folder, delete this file in the copy.\n",
				"\n",
				"%s\n" % (next_collection_id,),
				])
		new_filenames.append(filename)
		commit_message += "    %s: %s\n" % (next_collection_id, filename)

		print("saved ",filename)
		next_collection_id = succ_id(next_collection_id)

	if len(new_filenames) == 0:
		print("Done: No new id needed.") 
		return True
	 
	with open(next_ids_filename,"w") as f:
		f.writelines([
			"# Automatically created file. Do NOT edit.\n",
			"# If you copy the containing folder, delete this file in the copy.\n",
			"\n",
			"next_collection_id: %s\n" % (next_collection_id,),
			])
		print("saved ",next_ids_filename)
		commit_message += "    updated %s\n" % (next_ids_filename,)
		new_filenames.append(next_ids_filename)
		
	for filename in new_filenames:
		index.add([filename])


	final_commit = index.commit(commit_message)
	print("final_commit.type:",final_commit.type)		

	#repo.active_branch.commit = repo.commit('HEAD~1')     



update_ids()
