# AUTHOR: Chukwuemeka L. Nkama
# Date: 1/27/2024

git clone https://github.com/NVlabs/neuralangelo.git
cd ./neuralangelo/
git submodule update --init --recursive # init colmap submodule

# Name of video
VID=$1

# move video to neuralangelo directory
cp ../${VID} .

# Install additional libraries with version locking
pip install filetype==1.2.0 gradio==4.44.1 asyncer==0.0.8 onnxruntime==1.16.3 watchdog==4.0.2 aiohttp==3.10.11 rembg==2.0.61

# Define environmental variables
SEQUENCE="${VID%.*}"
PATH_TO_VIDEO=${VID}
DOWNSAMPLE_RATE=2
SCENE_TYPE=object

# Extract Colmap poses
nohup bash ../preprocess.sh ${SEQUENCE} ${PATH_TO_VIDEO} ${DOWNSAMPLE_RATE} ${SCENE_TYPE} & 

# Get PID of training process
PID=$!

# Wait for process to run finish
wait $PID
