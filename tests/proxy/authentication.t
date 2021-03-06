
  $ . ${TESTDIR}/setup_test_env.sh
  $ cd ${TESTTMP}

  $ git clone -q http://localhost:8001/real_repo.git
  warning: You appear to have cloned an empty repository.

  $ cd ${TESTTMP}/real_repo

  $ git status
  On branch master
  
  No commits yet
  
  nothing to commit (create/copy files and use "git add" to track)

  $ mkdir sub1
  $ echo contents1 > sub1/file1
  $ git add sub1
  $ git commit -m "add file1"
  [master (root-commit) *] add file1 (glob)
   1 file changed, 1 insertion(+)
   create mode 100644 sub1/file1

  $ tree
  .
  `-- sub1
      `-- file1
  
  1 directory, 1 file

  $ git push
  To http://localhost:8001/real_repo.git
   * [new branch]      master -> master

  $ cd ${TESTTMP}

  $ export TESTPASS=$(curl -s http://localhost:8001/_make_user/testuser)

  $ git clone -q http://testuser:wrongpass@localhost:8002/real_repo.git full_repo
  fatal: Authentication failed for 'http://localhost:8002/real_repo.git/'
  [128]

  $ rm -Rf full_repo

  $ git clone -q http://testuser:${TESTPASS}@localhost:8002/real_repo.git full_repo

  $ cd full_repo
  $ tree
  .
  `-- sub1
      `-- file1
  
  1 directory, 1 file

  $ cat sub1/file1
  contents1

  $ echo contents1 > file2
  $ git add .
  $ git commit -m "push test"
  [master *] push test (glob)
   1 file changed, 1 insertion(+)
   create mode 100644 file2
  $ git push
  remote: josh-proxy        
  remote: response from upstream:        
  remote:  To http://localhost:8001/real_repo.git        
  remote:  * (glob)
  remote: 
  remote: 
  To http://localhost:8002/real_repo.git
     *..*  master -> master (glob)

  $ rm -Rf full_repo
  $ git clone -q http://x\':bla@localhost:8002/real_repo.git full_repo
  fatal: unable to access 'http://localhost:8002/real_repo.git/': The requested URL returned error: 500
  [128]
  $ tree
  .
  |-- file2
  `-- sub1
      `-- file1
  
  1 directory, 2 files

  $ cd ${TESTTMP}/real_repo
  $ curl -s http://localhost:8001/_noauth
  $ git pull --rebase 2> /dev/null
  Updating *..* (glob)
  Fast-forward
   file2 | 1 +
   1 file changed, 1 insertion(+)
   create mode 100644 file2
  $ git log --graph --pretty=%s
  * push test
  * add file1

  $ bash ${TESTDIR}/destroy_test_env.sh
  refs
  |-- heads
  |-- josh
  |   |-- filtered
  |   |   `-- real_repo.git
  |   |       |-- %3A%2Fsub1
  |   |       |   `-- heads
  |   |       |       `-- master
  |   |       `-- %3Anop
  |   |           `-- heads
  |   |               `-- master
  |   `-- upstream
  |       `-- real_repo.git
  |           `-- refs
  |               `-- heads
  |                   `-- master
  |-- namespaces
  `-- tags
  
  14 directories, 3 files
