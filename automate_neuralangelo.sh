# AUTHOR: Chukwuemeka L. Nkama
# Date: 1/27/2024

# Build Neuralangelo image if it does not exist
if [ -z "$(docker images -q neural_img)" ]; then
  docker build -t neural_img -f Dockerfile-neuralangelo .
fi

# Define neuralangelo container
NEURAL="container_neuralangelo"

# Name of video
VID=$1

# start neural container 
if [ "$(docker ps -aq -f name=${NEURAL})" ]; then
  # if container exists, start it
  docker start ${NEURAL}
else
  # if container doesn't exist, create it
  docker run -d --gpus all --ipc=host --name ${NEURAL} neural_img tail -f /dev/null
fi

# Create workspace folder, if exists will ignore
docker exec ${NEURAL} bash -c "mkdir /workspace"

# transfer neuralangelo directory to main training container
docker cp ./neuralangelo ${NEURAL}:/workspace/ &
wait

# some recent git versions flag folders with different user privileges, add folder as a safe directory
docker exec ${NEURAL} bash -c "git config --global --add safe.directory /workspace/neuralangelo"

# transfer preprocessing script 
docker cp ./preprocess.sh ${NEURAL}:/workspace/neuralangelo/projects/neuralangelo/scripts/

# transfer mesh processing script
docker cp ./processor.py ${NEURAL}:/workspace/neuralangelo/

# Delete neuralangelo directory
# rm -rf ./neuralangelo

# Copy reconstruction script
docker cp ./reconstruct.sh ${NEURAL}:/workspace/neuralangelo/

# Train the model and extract the mesh
docker exec --workdir /workspace/neuralangelo ${NEURAL} bash -c "source reconstruct.sh ${VID}" &

# wait for mesh to be generated
DONE_PID=$!
wait $DONE_PID

# Copy final mesh
RESULT_MESH="res.ply"
workdir="/workspace/neuralangelo"

if docker exec -w $workdir ${NEURAL} test -e ${RESULT_MESH}; then
  # Check if the final file exists
  docker cp ${NEURAL}:$workdir/$RESULT_MESH .
  echo "Final mesh has been copied to the current working directory."
else
  echo "Final mesh does not exist in the container."
fi
