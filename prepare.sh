DIR=`pwd`

m_error() {
  echo $1
  exit 2
}

install_go() {
  cd ${DIR}
  if [ ! -f go1.13.linux-amd64.tar.gz ]; then
   if ! wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz; then
     m_error "Unable to download Go lang 1.13 from Google!"
   fi
  fi
  if [ ! -d ${DIR}/go ]; then
    tar xvfz go1.13.linux-amd64.tar.gz
  fi
}

install_symbolset() {
  cd ${DIR}
  if [ ! -d src ]; then
    mkdir src
  fi
  cd src
  if [ ! -d symbolset ]; then
    if ! git clone https://github.com/stts-se/symbolset.git; then
      m_error "Failed to clone Symbolset from git repo!"
    fi
    cd symbolset
  else
    cd symbolset
    git pull
  fi

  cd server
  if ! go build .; then
    m_error "Failed to build Symbolset!"
  fi

  if [ ! -d lexdata ]; then
    git clone git@github.com:stts-se/lexdata.git
  else
    cd lexdata
    if ! git pull; then
      m_error "Unable to update lexdata from git repo"
    fi
    cd ..
  fi

  /bin/bash setup.sh lexdata ss_files

  echo "Starting Symbolset server. Will wait a minute for it to start up and download any dependencies, and then kill it."
  ./server -ss_files ss_files &
  SYMBOLSET_PID=$!
  for i in $(seq 1 6); do
    sleep 10
    echo "${i}0/60 seconds slept before killing server..."
  done
  kill ${SYMBOLSET_PID}
}


if [ ! -d ${DIR}/go ]; then
  install_go
fi

export GOROOT=${DIR}/go
export GOPATH=${DIR}/goProjects
export PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}

install_symbolset

echo "Successfully prepared Symbolset! Now run ./build.sh"
