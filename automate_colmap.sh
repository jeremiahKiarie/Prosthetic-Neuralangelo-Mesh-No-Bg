# AUTHOR: Chukwuemeka L. Nkama
# Date: 1/27/2024

# Build Colmap image if it does not exist
if [ -z "$(docker images -q colmap_img)" ]; then
  docker build -t colmap_img -f Dockerfile-colmap .
fi

# Define colmap container
COLMAP="container_colmap"

# Name of video
VID=$1

# start colmap container
if [ "$(docker ps -aq -f name=${COLMAP})" ]; then
  # if container exists, start it
  docker start ${COLMAP}
else
  # if container doesn't exist, create it
  docker run -d --gpus all --ipc=host --name ${COLMAP} colmap_img tail -f /dev/null
fi

# Transfer video and get the colmap poses
docker cp ${VID} ${COLMAP}:/
docker cp ./colmap.sh ${COLMAP}:/
docker cp ./preprocess.sh ${COLMAP}:/
docker exec ${COLMAP} bash -c "source colmap.sh ${VID}"

# copy neuralangelo folder to current directory
docker cp ${COLMAP}:/neuralangelo . &
wait

# stop colmap container 
docker stop ${COLMAP}