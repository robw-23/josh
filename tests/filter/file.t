  $ export TESTTMP=${PWD}
  $ export PATH=${TESTDIR}/../../target/debug/:${PATH}

  $ cd ${TESTTMP}
  $ git init libs 1> /dev/null
  $ cd libs

  $ mkdir sub1
  $ echo contents1 > sub1/file1
  $ git add sub1
  $ git commit -m "add file1" 1> /dev/null

  $ echo contents2 > sub1/file2
  $ git add sub1
  $ git commit -m "add file2" 1> /dev/null


  $ mkdir sub2
  $ echo contents1 > sub2/file3
  $ git add sub2
  $ git commit -m "add file3" 1> /dev/null


  $ cat > file.josh <<EOF
  > c = :/sub1
  > a/b = :/sub2
  > EOF

  $ git add file.josh
  $ git commit -m "initial" 1> /dev/null

  $ josh-filter -s --file file.josh -p
  :/sub1:prefix=c
  :/sub2:prefix=b:prefix=a
  [1 -> 1] :prefix=a
  [1 -> 1] :prefix=b
  [2 -> 2] :prefix=c
  [4 -> 2] :/sub1
  [4 -> 2] :/sub2
  [4 -> 3] :(
      :/sub1:prefix=c
      :/sub2:prefix=b:prefix=a
  )
  $ git log --graph --pretty=%s JOSH_HEAD
  * add file3
  * add file2
  * add file1

  $ josh-filter -s --squash --file file.josh -p
  :SQUASH:/sub1:prefix=c
  :/sub2:prefix=b:prefix=a
  [2 -> 2] :prefix=a
  [2 -> 2] :prefix=b
  [3 -> 3] :prefix=c
  [5 -> 3] :/sub1
  [5 -> 3] :/sub2
  [5 -> 4] :(
      :/sub1:prefix=c
      :/sub2:prefix=b:prefix=a
  )
  $ git log --graph --pretty=%s JOSH_HEAD
  * initial

  $ tree .git/refs/
  .git/refs/
  |-- JOSH_HEAD
  |-- heads
  |   `-- master
  `-- tags
  
  2 directories, 2 files

